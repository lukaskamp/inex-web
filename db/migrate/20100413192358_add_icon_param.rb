class AddIconParam < ActiveRecord::Migration
  def self.up
    czech = Language.find_by_code('cs')
    english = Language.find_by_code('en')
    StringParameter.new(:key => 'admin_banners_icon', :value => 'banners.png').save

    Banner.create( :name => 'Fotbal pro rozvoj',
                   :language => czech,
                   :image_filename => 'fotbal_pro_rozvoj_cs.png',
                   :url => 'http://www.inexsda.cz/cs/Fotbal-pro-rozvoj',
                   :order => 10)

    Banner.create( :name => 'Football for Development',
                   :language => english,
                   :image_filename => 'fotbal_pro_rozvoj_en.png',
                   :url => 'http://www.inexsda.cz/cs/Fotbal-pro-rozvoj',
                   :order => 10)

    Banner.create( :name => 'Kostelecke Horky',
                   :language => english,
                   :image_filename => 'horky_en.png',
                   :url => 'http://www.inexsda.cz/en/training_centre',
                   :order => 20)

    Banner.create( :name => 'Kostelecke Horky',
                   :language => czech,
                   :image_filename => 'horky_cs.png',
                   :url => 'http://www.inexsda.cz/cs/skolici_centrum',
                   :order => 20)

  end

  def self.down
  end
end
