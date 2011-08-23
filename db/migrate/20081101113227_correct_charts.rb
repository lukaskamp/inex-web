class CorrectCharts < ActiveRecord::Migration
  def self.up
    remove_column :statistic_queries, :from
    remove_column :statistic_queries, :to
    remove_column :statistic_queries, :dynamic
    add_column :statistic_queries, :created_by, :integer
    add_column :statistic_queries, :updated_by, :integer
    change_column :statistic_queries, :term, :text
  end

  def self.down
    add_column :statistic_queries, :from, :date
    add_column :statistic_queries, :to, :date
    add_column :statistic_queries, :dynamic, :boolean
    remove_column :statistic_queries, :created_by
    remove_column :statistic_queries, :updated_by
    change_column :statistic_queries, :term, :string
  end
end
