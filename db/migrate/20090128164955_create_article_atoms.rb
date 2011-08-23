class CreateArticleAtoms < ActiveRecord::Migration
  def self.up
    add_column :articles, :url_atom, :string
    add_column :menu_items, :url_atom, :string
    
    for klass in [Article, MenuItem]
      klass.reset_column_information
      atoms = []
      klass.find(:all).each do |record|
        new_atom = InexUtils::string_for_url(record.title)
        new_atom = new_atom + "_" while atoms.include? new_atom
        atoms << new_atom
        record.url_atom = new_atom
        record.save!
      end
    end
    
    add_index :articles, :url_atom, :unique => true
    add_index :menu_items, :url_atom, :unique => true
  end

  def self.down
    remove_column :articles, :url_atom
    remove_column :menu_items, :url_atom
  end
end
