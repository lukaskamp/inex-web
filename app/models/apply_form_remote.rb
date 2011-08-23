class ApplyFormRemote < ActiveResource::Base
  self.site = ENV['volant_site']
  self.user = ENV['volant_user']
  self.password = ENV['volant_password']
  self.element_name = "apply_form"

  FORBIDDEN = ["id", "created_at", "updated_at", "submitted",
               "terms_of_workcamps", "terms_of_processing"]

  def self.create_from_local(form)
    params = {}
    attrs = form.attributes
    attrs.reject! { |key,value| FORBIDDEN.include?(key) }

    attrs.each do |key,value|
      params[key] = value
    end

    ApplyFormRemote.new(:apply_form => params)
  end


end
