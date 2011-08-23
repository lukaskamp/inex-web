class CreateStatisticQueries < ActiveRecord::Migration
  def self.up
    create_table :statistic_queries do |t|
      t.string :name
      t.string :field
      t.string :chart_type
      
      # dynamic queries
      t.string :term
      
      # static queries
      t.string :google_chart_url
      t.date :from
      t.date :to
      t.date :generated_at

      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :statistic_queries
  end
end
