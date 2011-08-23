class AddArticleToCzproj < ActiveRecord::Migration
  def self.up
    add_column :cz_projects, :article_id, :integer
  end

  def self.down
    remove_column :cz_projects, :article_id
  end
end
