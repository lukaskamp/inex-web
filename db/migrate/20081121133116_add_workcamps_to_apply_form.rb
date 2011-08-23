class AddWorkcampsToApplyForm < ActiveRecord::Migration
  def self.up
    add_column :apply_forms, :workcamps_ids, :text
  end

  def self.down
    remove_column :apply_forms, :workcamps_ids
  end
end
