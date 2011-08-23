class FixVariousColumns < ActiveRecord::Migration
  def self.up
    add_column :cz_projects, :project_code, :string
    remove_column :articles, :annotation
  end

  def self.down
    remove_column :cz_projects, :project_code
    add_column :articles, :annotation, :text
  end
end
