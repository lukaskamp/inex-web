class RemoveArticleRelations < ActiveRecord::Migration
  def self.up
    drop_table "article_relations"
  end

  def self.down
    create_table "article_relations", :force => true do |t|
      t.integer  "article_one_id"
      t.integer  "article_two_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
