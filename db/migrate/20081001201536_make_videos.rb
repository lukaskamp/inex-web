class MakeVideos < ActiveRecord::Migration
  def self.up
    add_column :media_files, :link, :string
    add_column :media_files, :linked_file, :integer
    add_column :media_files, :hidden, :integer
  end

  def self.down
    remove_column :media_files, :link
    remove_column :media_files, :linked_file
    remove_column :media_files, :hidden
  end
end
