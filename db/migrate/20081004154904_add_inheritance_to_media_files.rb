class AddInheritanceToMediaFiles < ActiveRecord::Migration
  def self.up
    rename_column :media_files, :content_type, :type
    add_column :media_files, :video_width, :integer
    add_column :media_files, :video_height, :integer
    add_column :media_files, :video_codec, :string
  end

  def self.down
    rename_column :media_files, :type, :content_type
    remove_column :media_files, :video_width
    remove_column :media_files, :video_height
    remove_column :media_files, :video_codec
  end
end
