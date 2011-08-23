class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.integer :language_id, :null => false
      t.integer :menu_item_id
      t.text :annotation
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
