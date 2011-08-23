class ChangeSurveyColumnTypes < ActiveRecord::Migration
  def self.up
    change_column :surveys, :whynot, :text
    change_column :surveys, :comments, :text
    change_column :surveys, :transport, :text
    change_column :surveys, :visa, :text
    change_column :surveys, :collcomment, :text
    change_column :surveys, :projcomment, :text
    change_column :surveys, :findcomment, :text
    change_column :surveys, :ratecomment, :text
  end

  def self.down
#     change_column :surveys, :whynot, :string
#     change_column :surveys, :comments, :string
#     change_column :surveys, :transport, :string
#     change_column :surveys, :visa, :string
#     change_column :surveys, :collcomment, :string
#     change_column :surveys, :projcomment, :string
#     change_column :surveys, :findcomment, :string
#     change_column :surveys, :ratecomment, :string
  end
end
