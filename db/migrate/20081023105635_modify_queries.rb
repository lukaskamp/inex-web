class ModifyQueries < ActiveRecord::Migration
  def self.up
    remove_column :statistic_queries, :chart_type
    add_column :statistic_queries, :dynamic, :boolean, :null => false, :default => true
  end

  def self.down
    add_column :statistic_queries, :chart_type, :string
  end
end
