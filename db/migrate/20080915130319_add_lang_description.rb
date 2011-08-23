class AddLangDescription < ActiveRecord::Migration
  def self.up
    change_table :languages do |t|
      t.string :link_title
    end
  end
  
  def self.down
    change_table :languages do |t|
      t.remove :link_title
    end
  end
end
