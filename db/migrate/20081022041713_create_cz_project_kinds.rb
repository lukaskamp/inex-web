class CreateCzProjectKinds < ActiveRecord::Migration
  def self.up
    create_table :cz_project_kinds do |t|
      t.string :title_btkey
      t.string :description_btkey
      t.string :icon

      t.timestamps
    end
  end

  def self.down
    drop_table :cz_project_kinds
  end
end
