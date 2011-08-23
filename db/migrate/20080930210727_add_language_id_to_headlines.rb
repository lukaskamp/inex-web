class AddLanguageIdToHeadlines < ActiveRecord::Migration
  def self.up
    add_column :headlines, :language_id, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :headlines, :language_id
  end
end
