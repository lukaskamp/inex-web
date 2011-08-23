class AddTextsToHeadline < ActiveRecord::Migration
  def self.up
    add_column :headlines, :annotation_explicit, :text
    add_column :headlines, :body_explicit, :text
    add_column :headlines, :image_filename, :string
  end

  def self.down
    remove_column :headlines, :annotation_explicit
    remove_column :headlines, :body_explicit
    remove_column :headlines, :image_filename
  end
end
