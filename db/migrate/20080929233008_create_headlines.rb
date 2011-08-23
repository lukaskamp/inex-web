class CreateHeadlines < ActiveRecord::Migration
  def self.up
    create_table :headlines do |t|
      t.string :title, :null => false
      t.integer :article_id
      t.date :valid_from
      t.date :valid_to

      t.timestamps
    end
  end

  def self.down
    drop_table :headlines
  end
end
