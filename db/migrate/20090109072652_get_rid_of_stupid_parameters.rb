class GetRidOfStupidParameters < ActiveRecord::Migration
  def self.up
    Parameter.delete(Parameter.find_by_key('special_article_wiki').id)
    Parameter.delete(Parameter.find_by_key('special_article_football').id)
    Parameter.delete(Parameter.find_by_key('special_article_horky').id)
    Parameter.delete(Parameter.find_by_key('special_article_contact').id)
  end

  def self.down
    p StringParameter.create(:key => 'special_article_wiki', :value => 'wiki', :description => 'Special-article key for Volunteer WIKI (homepage button).')
    p StringParameter.create(:key => 'special_article_football', :value => 'football', :description => 'Special-article key for Football (homepage button).')
    p StringParameter.create(:key => 'special_article_horky', :value => '', :description => 'Special-article key for Kostelecke Horky (homepage button).')
    p StringParameter.create(:key => 'special_article_contact', :value => '', :description => 'Special-article key for contact link.')
  end
end
