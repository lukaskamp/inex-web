class Language < ActiveRecord::Base

  has_many :articles, :order => "updated_at DESC, created_at DESC, title"
  has_many :builtin_texts, :order => "name"
  has_many :media_albums, :order => "position, title, filename"

  def to_label
		link_title
  end

  def to_s
    code
  end

  def self.find_by_code(code)
    Language.find(:first, :conditions => [ "code = ?", code ] )    
  end
  
  def self.default
    find_by_code('cs')
  end
  
end
