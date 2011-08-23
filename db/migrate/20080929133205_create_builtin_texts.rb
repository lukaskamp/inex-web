class CreateBuiltinTexts < ActiveRecord::Migration
  def self.up
    create_table :builtin_texts do |t|
      t.string :name
      t.text :body
      t.integer :language_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :builtin_texts
  end
end
