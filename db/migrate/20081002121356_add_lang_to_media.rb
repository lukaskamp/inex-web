class AddLangToMedia < ActiveRecord::Migration
  def self.up
    add_column :media_albums, :language_id, :integer
  end

  def self.down
    remove_column :media_albums, :language_id
  end
end
