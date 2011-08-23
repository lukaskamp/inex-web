class CreateArticleRelations < ActiveRecord::Migration
  def self.up
    create_table :article_relations do |t|
      t.integer :article_one_id
      t.integer :article_two_id

      t.timestamps
    end
  end

  def self.down
    drop_table :article_relations
  end
end
