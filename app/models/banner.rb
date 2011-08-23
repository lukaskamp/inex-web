class Banner < ActiveRecord::Base
  belongs_to :language
  validates_presence_of :url, :image_filename, :name, :language

  def self.find_by_language(lang)
    find(:all, :conditions => [ 'language_id = ?', lang.id ])
  end
end
