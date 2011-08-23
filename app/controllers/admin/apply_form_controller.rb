class Admin::ApplyFormController < Admin::AdminController

 active_scaffold :apply_form do |config|
    config.label = "Workcamps Application Forms"

    list.sorting = { :created_at => 'DESC'}
    config.list.columns = [ :name, :phone, :workcamps_names, :submitted, :submission_status ]

    # FIXME
    if false
      config.columns = [ :firstname, :lastname, :gender,
                         :email, :fax, :phone
                       ]
    end

    config.columns.exclude :workcamps_ids
    config.actions.exclude :create, :delete

    action_link config, 'submit', 'Resubmit to Volant', 'admin_send_email', :type => :record
  end


  def submit
    @form = ApplyForm.find(params[:id])
    @form.submit
    redirect_to :action => :index
  end

  def workcamp_connection_check
    render :update do |page|
      # FIXME - write working test!!!
      if true
        image = icon('ok')
        message = 'Connection is OK'
      else
        image = icon('fail')
        message = 'Connection to workcamp database failed - please contact administrator!'
      end

      page.replace_html  'connection_message', "#{image} #{Time.now.to_s}: #{message}"
    end
  end

end
