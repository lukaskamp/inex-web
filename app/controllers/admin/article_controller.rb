class Admin::ArticleController < Admin::AdminController  
    
  active_scaffold :article do |config|
    config.label = "Articles"
    config.create.link.label = "Write a New Article"
    list.sorting = {:updated_at => 'DESC'}
    
    config.columns = [ :url_atom, :title, :body, :article_relations, :created_at, :created_by, :updated_at, :updated_by]                       
    list.columns =   [ :url_atom, :title, :body ]
    
    config.columns[:url_atom].description = "URL part: consists only of english letters, hyphens and numbers"

    config.columns[:title].required = true
    config.columns[:body].label = 'Article Text'
    config.show.link.label = 'Details'

    action_link config, 'view_online', 'View online', 'admin_web', :type => :record
    action_link config, 'create_headline', 'Create headline', 'admin_headlines', :type => :record
                            
    exclude_user_cols_from_edit(config)
  end
  
  # must be included after the 'active_scaffold' call to work
  include LanguageAware
  
  def do_new
    super
    @show_article_relations = false
  end
  
  def do_edit
    super
    @show_article_relations = true
    @other_languages = Language.find(:all, :order => "code", :conditions => ["id <> ?", @record.language.id])
    @articles = {}
    for lang in @other_languages do
      @articles[lang.code] = Article.find(:all, :order => "title", :conditions => ["language_id = ?", lang.id])
    end
  end
  
  def do_update
    super
    for language_id, article_id in params[:article_relation]
      @record.add_language_version(Article.find(article_id)) if article_id and article_id.to_i > 0
    end
  end
  
  def create_headline
    article = Article.find(params[:id])
    redirect_to :controller => "admin/headline", :action =>"new", :headline_title => article.title, :headline_article => article.id
  end
  
  # Redirects user from admin space to web view of the article.
  def view_online
    redirect_to article_path(:language_code => @current_language.code, :url_atom => Article.find(params[:id]).url_atom)
  end
   
#  def body_column(record)
#    sanitize(record.body)
#  end
  
end
