class AddCreatedAndUpdatedBy < ActiveRecord::Migration
  
  TABLES_TO_CHANGE = [ :articles, :headlines, :builtin_texts, 
                       :menu_items, :parameters ]
    
  def self.up
    TABLES_TO_CHANGE.each do |table|
      add_column table, :created_by_id, :integer
      add_column table, :updated_by_id, :integer
    end
  end

  def self.down
     TABLES_TO_CHANGE.each do |table|
       remove_column table, :created_by_id
       remove_column table, :updated_by_id
     end
  end
end
