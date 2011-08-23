class AddMenuSettingsToUser < ActiveRecord::Migration
  def self.up
    # FIXME - the default value doesn't work
    add_column :users, :show_advanced_menu, :boolean, :default => 'FALSE'
  end

  def self.down
    remove_column :users, :show_advanced_menu
  end
end
