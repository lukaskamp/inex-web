class CzProjectIconToKind < ActiveRecord::Migration
  def self.up
    remove_column :cz_projects, :icon
    add_column :cz_projects, :kind_id, :integer
  end

  def self.down
    add_column :cz_projects, :icon, :string
    remove_column :cz_projects, :kind_id
  end
end
