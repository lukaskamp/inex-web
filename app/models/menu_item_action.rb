class MenuItemAction < MenuItem

  def target_url
    {:route => nil, :controller => target_controller, :action => target_action, :additional_parameters => target_parameters}
  end
  
  def target_label
    "#{target_controller}/#{target_action||"index"}"+((target_parameters and not target_parameters.empty?)?("?#{target_parameters}"):(""))
  end

  def self.menu_type_description
    "This menu item points to an internal action (filling in a survey, opening a list of LTV project etc.). You need to fill in the Rails controller+action; for list of available actions see the 'Advanced / List of available actions' menu item."
  end

  def self.required_fields
    [:controller, :action]
  end
  
end