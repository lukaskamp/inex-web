class CreateLtvProjects < ActiveRecord::Migration
  def self.up
    create_table :ltv_projects do |t|
      t.string :title
      t.string :country
      t.string :organization
      t.text :description
      t.text :fulltext
      t.string :filename
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ltv_projects
  end
end
