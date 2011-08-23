class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.string :key
      t.string :value
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
