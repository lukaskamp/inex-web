class CreateEvsProjects < ActiveRecord::Migration
  def self.up
    create_table :evs_projects do |t|
      t.string :eiref
      t.string :eid
      t.string :country
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :evs_projects
  end
end
