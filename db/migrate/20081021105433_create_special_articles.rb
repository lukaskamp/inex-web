class CreateSpecialArticles < ActiveRecord::Migration
  def self.up
    create_table :special_articles do |t|
      t.string :key
      t.integer :meta_article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :special_articles
  end
end
