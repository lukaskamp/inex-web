class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :name, :null => false
      t.string :url, :limit => 2048, :null => false
      t.string :image_filename, :limit => 2048, :null => false
      t.integer :language_id, :null => false
      t.integer :order, :null => false, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
