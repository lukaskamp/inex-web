class AddLanguageToCzproj < ActiveRecord::Migration
  def self.up
    add_column :cz_projects, :language_id, :integer
  end

  def self.down
    remove_column :cz_projects, :language_id
  end
end
