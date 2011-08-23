class AddMetaToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :meta_article_id, :integer
  end

  def self.down
    remove_column :articles, :meta_article_id
  end
end
