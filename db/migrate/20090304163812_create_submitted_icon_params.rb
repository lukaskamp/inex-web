class CreateSubmittedIconParams < ActiveRecord::Migration
  def self.up
    StringParameter.new(:key => 'admin_submitted_error_icon', :value => 'cancel.png').save
    StringParameter.new(:key => 'admin_submitted_icon', :value => 'accept.png').save
    remove_column :apply_forms, :emails_sent
    add_column :apply_forms, :submission_status, :string, :limit => '512'
  end

  def self.down
    StringParameter.find_by_key('admin_submitted_icon').destroy
    StringParameter.find_by_key('admin_submitted_error_icon').destroy
    add_column :apply_forms, :emails_sent, :boolean
    remove_column :apply_forms, :submission_status
  end
end
