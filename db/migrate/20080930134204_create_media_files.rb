class CreateMediaFiles < ActiveRecord::Migration
  def self.up
    create_table :media_files do |t|
      t.string :filename
      t.string :name
      t.integer :media_album_id
      t.text :description
      t.string :content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :media_files
  end
end
