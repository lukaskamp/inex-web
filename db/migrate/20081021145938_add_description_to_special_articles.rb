class AddDescriptionToSpecialArticles < ActiveRecord::Migration
  def self.up
    add_column :special_articles, :description, :string
  end

  def self.down
    remove_column :special_articles, :description
  end
end
