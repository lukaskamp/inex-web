class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.string :title, :null => false
      t.integer :position, :null => false
      t.integer :parent_id
      t.integer :language_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_items
  end
end
