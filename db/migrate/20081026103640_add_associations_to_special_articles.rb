class AddAssociationsToSpecialArticles < ActiveRecord::Migration
  def self.up
    add_column :special_articles, :associated_controller, :string
    add_column :special_articles, :associated_action, :string
  end

  def self.down
    remove_column :special_articles, :associated_controller
    remove_column :special_articles, :associated_action
  end
end
