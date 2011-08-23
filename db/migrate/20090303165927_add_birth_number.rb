class AddBirthNumber < ActiveRecord::Migration
  def self.up
    add_column :apply_forms, :birthnumber, :string
  end

  def self.down
    remove_column :apply_forms, :birthnumber
  end
end
