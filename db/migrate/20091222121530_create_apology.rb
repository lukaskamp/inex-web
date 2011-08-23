class CreateApology < ActiveRecord::Migration
  def self.up
    cs = "Omlouváme se, ale vyhledáváná workcampů není v současné době k dispozici. Na nápravě se pracuje."
    en = "Workcamp search is not available at the moment. We apologize for any inconvenience caused."

    BuiltinText.new(:name => 'wc_sorry', :body => en,:language => Language.find_by_code('en') ).save
    BuiltinText.new(:name => 'wc_sorry', :body => cs,:language => Language.find_by_code('cs') ).save
  end

  def self.down
    BuiltinText.find(:all, :conditions => [ 'name = ?', 'wc_sorry' ]).each { |c| c.destroy }
  end
end
