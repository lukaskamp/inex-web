class MetaArticle < ActiveRecord::Base
  
  has_many :articles
  has_one :special_article
  
  include InexHelpers
  
  def to_label
    articles.map{|a| help.truncate(a.title,15)+"[#{a.id}]"}*"/"
  end
  
  def to_s
    to_label
  end
  
end
