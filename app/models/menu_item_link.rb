class MenuItemLink < MenuItem
  
  def target_label
    target_link || ""
  end

  def self.required_fields
    [:link]
  end

  def self.menu_type_description
    "This menu item points to an external location, specified by the link."
  end
  
end