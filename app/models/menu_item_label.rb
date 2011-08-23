class MenuItemLabel < MenuItem
  
  def target_url
    nil
  end
  
  def target_label
    self.title
  end

  def self.menu_type_description
    "This menu item acts as a label - it won't be clickable and will be rendered in a special way."
  end
  
end