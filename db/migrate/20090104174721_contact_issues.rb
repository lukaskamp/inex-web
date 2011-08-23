class ContactIssues < ActiveRecord::Migration
  def self.up
      p StringParameter.create(:key => 'special_article_contact', :value => '', :description => 'Special-article key for contact link.')
    end

    def self.down
      Parameter.delete(Parameter.find_by_key('special_article_contact').id)
  end
end
