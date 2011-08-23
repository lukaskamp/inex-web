class ModifyCzProjects < ActiveRecord::Migration
  def self.up
    remove_column :cz_projects, :description
    remove_column :cz_projects, :language_id
    remove_column :cz_projects, :article_id
    add_column :cz_projects, :description_long, :text
    add_column :cz_projects, :description_short, :string
    add_column :cz_projects, :geocode, :string
  end

  def self.down
    add_column :cz_projects, :description, :text
    add_column :cz_projects, :language_id, :integer
    add_column :cz_projects, :article_id, :integer
    remove_column :cz_projects, :description_long
    remove_column :cz_projects, :description_short
    remove_column :cz_projects, :geocode
  end
end