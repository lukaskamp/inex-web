class AddSizesToCharts < ActiveRecord::Migration
  def self.up
    add_column :statistic_queries, :width, :integer
    add_column :statistic_queries, :height, :integer
  end

  def self.down
    remove_column :statistic_queries, :width
    remove_column :statistic_queries, :height
  end
end
