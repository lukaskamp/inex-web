class WidenGoogleUrlColumn < ActiveRecord::Migration
  def self.up
    change_column :statistic_queries, :google_chart_url, :string, :limit => 2048
  end

  def self.down
    change_column :statistic_queries, :google_chart_url, :string, :limit => 255
  end
end
