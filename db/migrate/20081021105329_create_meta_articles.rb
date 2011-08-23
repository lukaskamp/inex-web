class CreateMetaArticles < ActiveRecord::Migration
  def self.up
    create_table :meta_articles do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :meta_articles
  end
end
