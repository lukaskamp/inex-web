class CreateCzProjects < ActiveRecord::Migration
  def self.up
    create_table :cz_projects do |t|
      t.string :title
      t.text :description
      t.string :latitude
      t.string :longitude
      t.string :icon

      t.timestamps
    end
  end

  def self.down
    drop_table :cz_projects
  end
end
