class AddIconsToCzprojects < ActiveRecord::Migration
  def self.up
    add_column :cz_project_kinds, :marker_btkey, :string
  end

  def self.down
    remove_column :cz_project_kinds, :marker_btkey
  end
end
