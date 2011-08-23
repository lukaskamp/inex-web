class SpecialArticle < ActiveRecord::Base
  
  belongs_to :meta_article
  validates_uniqueness_of :key
  
  def to_label
    self.key
  end
  
  def to_s
    to_label
  end
  
  def self.find_by_key(the_key, language)
    special = SpecialArticle.find(:first, :conditions => ["key = ?", the_key])
    return nil unless special
    articles = special.meta_article.articles.select{|x| x.language == language}
    articles.first
  end
  
  def self.find_id_by_key(the_key, language)
    a = SpecialArticle.find_by_key(the_key, language)
    a ? a.id : 0 
  end
  
  def self.find_atom_by_key(the_key, language)
    a = SpecialArticle.find_by_key(the_key, language)
    a ? a.url_atom : "_" 
  end
  
end
