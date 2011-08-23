class CreateSiteActions < ActiveRecord::Migration
  def self.up
    create_table :site_actions do |t|
      t.string :title
      t.string :controller
      t.string :action

      t.timestamps
    end
  end

  def self.down
    drop_table :site_actions
  end
end
