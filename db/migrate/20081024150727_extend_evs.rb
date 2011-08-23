class ExtendEvs < ActiveRecord::Migration
  def self.up
    add_column :evs_projects, :description, :text
    add_column :evs_projects, :link, :string
  end

  def self.down
    remove_column :evs_projects, :description
    remove_column :evs_projects, :link
  end
end
