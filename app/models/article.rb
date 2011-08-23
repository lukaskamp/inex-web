class Article < ActiveRecord::Base

  include ActAsAuthored
  include InexHelpers

        belongs_to :language
        belongs_to :meta_article

        validates_presence_of :title, :language
  validates_url_atom
  acts_as_indexed :fields => [:title, :body]

  include LanguageAware


  def fulltext_formatter_name
    "format_article_for_fulltext"
  end

  def to_label
    help.truncate(title, 30)
  end

  # relation methods

  def special_article
    return nil unless meta_article
    meta_article.special_article
  end

  def meta_article!
    unless self.meta_article
      meta = MetaArticle.create
      self.meta_article = meta
      self.save
    end
    self.meta_article
  end

  def self.get_in_language(id,language)
    article = Article.first(:conditions => {:id => id})
    return nil unless article
    article.language_version(language)
  end

  def language_version(language)
    return self if self.language == language
    return nil unless meta_article

    others = meta_article.articles(true).select {|a| language == a.language}

    return nil if others.size == 0
    RAILS_DEFAULT_LOGGER.warn "Inconsistent language relations." if others.size > 1

    others.first
  end

  def add_language_version(other_article)
    other_article.remove_myself_as_language_version

    another_article = self.language_version(other_article.language)
    another_article.remove_myself_as_language_version if another_article

    if meta_article
      other_article.meta_article = self.meta_article
    else
      new_meta = MetaArticle.create
      other_article.meta_article = new_meta
      self.meta_article = new_meta
    end
    other_article.save
    self.save
  end

  def remove_myself_as_language_version
    if the_meta = self.meta_article
      self.meta_article = nil
      self.save
      if the_meta.articles(true).size == 0
        if sa=the_meta.special_article(true)
          sa.meta_article = nil
          sa.save
        end
        MetaArticle.delete(the_meta)
      end
    end
  end

  # just a 'stupid' lister gathering all language versions

  def article_relations
    return "" unless meta_article
    list = []
    for a in (meta_article.articles - [self]) do
      list.push(a.language.code + "=>" + a.title)
    end
    list*", "
  end

end
