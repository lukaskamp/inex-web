class RenameMediaTitle < ActiveRecord::Migration
  def self.up
    rename_column :media_albums, :name, :title
    rename_column :media_files, :name, :title
    rename_column :media_albums, :directory_name, :filename
  end

  def self.down
    rename_column :media_albums, :title, :name
    rename_column :media_files, :title, :name
    rename_column :media_albums, :filename, :directory_name
  end
end
