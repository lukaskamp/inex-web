class AddVirtualToMediafile < ActiveRecord::Migration
  def self.up
    add_column :media_files, :virtual, :integer
  end

  def self.down
    remove_column :media_files, :virtual
  end
end
