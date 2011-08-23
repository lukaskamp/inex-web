class CreateMediaAlbums < ActiveRecord::Migration
  def self.up
    create_table :media_albums do |t|
      t.string :directory_name
      t.string :name
      t.integer :media_album_id
      t.text :description
      t.integer :cover_id

      t.timestamps
    end
  end

  def self.down
    drop_table :media_albums
  end
end
