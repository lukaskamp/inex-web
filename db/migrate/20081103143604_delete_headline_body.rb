class DeleteHeadlineBody < ActiveRecord::Migration
  def self.up
    remove_column :headlines, :body_explicit
  end

  def self.down
    add_column :headlines, :body_explicit, :text
  end
end
