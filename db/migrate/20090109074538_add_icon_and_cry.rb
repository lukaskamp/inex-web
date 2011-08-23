class AddIconAndCry < ActiveRecord::Migration
  def self.up
    p StringParameter.create(:key => 'admin_help_icon', :value => 'help.png', :description => '')
  end

  def self.down
    Parameter.delete(Parameter.find_by_key('admin_help_icon').id)
  end
end
