class AddInheritanceToMenuItems < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :type, :string
    add_column :menu_items, :target_id, :integer
    add_column :menu_items, :target_link, :string
    add_column :menu_items, :target_controller, :string
    add_column :menu_items, :target_action, :string
    add_column :menu_items, :target_parameters, :string
  end

  def self.down
    remove_column :menu_items, :type
    remove_column :menu_items, :target_id
    remove_column :menu_items, :target_link
    remove_column :menu_items, :target_controller
    remove_column :menu_items, :target_action
    remove_column :menu_items, :target_parameters
  end
end
