class ApplyForm < ActiveRecord::Base

    serialize :workcamps_ids, Array

    composed_of :address, :class_name => 'Address', :mapping => address_mapping do |params|
      Address.new params[:street], params[:city], params[:zipcode]
    end

    composed_of :contact_address, :class_name => 'Address', :mapping => address_mapping('contact_') do |params|
      Address.new params[:street], params[:city], params[:zipcode]
    end

    validates_associated :address
    validates_inclusion_of :gender, :in => %w( m f )
    validates_format_of :birthnumber, :with => /\d{9}\d?/

    # agreements
    validates_acceptance_of :terms_of_processing, :allow_nil => false, :accept => true
    validates_acceptance_of :terms_of_workcamps, :allow_nil => false, :accept => true

    # phones
    [ :emergency_day, :emergency_night, :phone ].each do |attr|
      validates_length_of attr, :minimum => 6
    end


    REQUIRED_FIELDS = [ :firstname, :lastname,
                        :nationality, :occupation,
                        :birthnumber, :birthdate,
                        :email,
                        :phone,
                        :gender,
                        :address,
                        :motivation,
                        :emergency_name,
                        :emergency_day,
                        :emergency_night,
                        :workcamps_ids
                      ]

    REQUIRED_FIELDS.each { |field| validates_presence_of field, :message => "must_not_be_empty" }

    def after_initialize
      self.workcamps_ids ||= []
    end

    def submit
      # submission to remote system doesn't affect the user
      begin
        remote = ApplyFormRemote.create_from_local(self)

        if remote.save
          self.submitted = Time.now
          self.submission_status = nil
          self.save
          return true
        else
          self.submitted = nil
          self.submission_status = remote.errors.full_messages.join(',')
          self.save
          return false
        end
      rescue
        self.submitted = nil
        self.submission_status = $!
        logger.warn "Failed to submit application to Volant: #{$!}"
        false
      end
    end

    def name
      "#{firstname} #{lastname}"
    end

    def self.require?( field)
      REQUIRED_FIELDS.include? field
    end

    def workcamps
      Workcamp.find_all(workcamps_ids)
    end

    def workcamps_names
      workcamps.to_label
    end

    # Adds workcamp to application form - either object, ID or array of both is accepted.
    def add_workcamp(workcamp)
      case workcamp
        when Workcamp
          id = workcamp.id
        when Integer
          id = workcamp
        when Array
          workcamp.each { |one| self.add_workcamp(one) }
          return
      end

      (workcamps_ids << id) unless workcamps_ids.include? id
    end

  end
