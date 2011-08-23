class AddPartnerParameters < ActiveRecord::Migration
  def self.up
    p StringParameter.create(:key => 'partner_logos', :value => 'vesmirna_logo.gif,cestadomu_logo.gif', :description => 'Comma-separated image filenames of partner logos.')
    p StringParameter.create(:key => 'partner_main_logo', :value => 'dcce_logo.jpg', :description => 'Image filename of the main partner logo.')
    p StringParameter.create(:key => 'special_article_wiki', :value => 'wiki', :description => 'Special-article key for Volunteer WIKI (homepage button).')
    p StringParameter.create(:key => 'special_article_football', :value => 'football', :description => 'Special-article key for Football (homepage button).')
    p StringParameter.create(:key => 'special_article_horky', :value => '', :description => 'Special-article key for Kostelecke Horky (homepage button).')
  end

  def self.down
    Parameter.delete(Parameter.find_by_key('partner_logos').id)
    Parameter.delete(Parameter.find_by_key('partner_main_logo').id)
    Parameter.delete(Parameter.find_by_key('special_article_wiki').id)
    Parameter.delete(Parameter.find_by_key('special_article_football').id)
    Parameter.delete(Parameter.find_by_key('special_article_horky').id)
  end
end
