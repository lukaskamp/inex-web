class AddPositionToMedia < ActiveRecord::Migration
  def self.up
    add_column :media_albums, :position, :integer
    add_column :media_files, :position, :integer
  end

  def self.down
    remove_column :media_albums, :position
    remove_column :media_files, :position
  end
end
