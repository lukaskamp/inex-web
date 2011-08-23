class AddToApplyFormEmailsSent < ActiveRecord::Migration
  def self.up
    add_column :apply_forms, :emails_sent, :boolean, :null => false, :default => false
    add_column :apply_forms, :submitted, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :apply_forms, :emails_sent
    remove_column :apply_forms, :submitted
  end
end
