class Admin::SpecialArticlesController < Admin::AdminController

  # TODO: forbid any changes to nonadmin

  active_scaffold :special_article do |config|
#    list.columns = [:key, :description, :meta_article]
    config.columns = [ :key, :description, :meta_article, :associated_controller, :associated_action ]
  end
  
  def prepare_meta_articles
    @meta_articles = MetaArticle.find(:all)
    @articles = Article.find(:all, :order => "title", :conditions => ["meta_article_id IS NULL AND language_id = ?", @current_language.id])
  end
  
  def process_meta_articles
    if params[:meta_article]
      type, id = params[:meta_article].split(":")
      if type == "a"
        @record.meta_article = Article.find(id.to_i).meta_article!
      else
        @record.meta_article_id = id.to_i
      end
      @record.save
    end
  end
  
  def do_new
    super
    prepare_meta_articles
  end
  
  def do_edit
    super
    prepare_meta_articles
  end
  
  def do_update
    super
    process_meta_articles
  end
  
  def do_create
    super
    process_meta_articles
  end
  
end
