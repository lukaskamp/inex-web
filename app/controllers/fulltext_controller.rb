class FulltextController < PublicController

  include LanguageAware
  
  def index
    
  end
  
  def terms(query)
    # extract terms out of the query:
    # 1) in quoted terms, replace spaces by tildes
    q = query.dup.gsub(/".+?"/) do |match|
          match[0].gsub('"','').gsub(' ','~')
        end
      
    # 2) now: 
    #  a) split the query by spaces
    #  b) reject ANDs and ORs (they are not terms)
    #  c) reject terms starting with -
    #  d) remove + in beginning of a term
    #  e) change tildes in terms back to spaces 
    q.split.reject{|x| ["AND","OR"].include? x}.reject{|x| x[0..0]=="-"}.map{|x| (x[0..0]=="+")?(x[1..-1]):(x)}.map{|x| x.gsub('~',' ')}
  end
  
  
  def load_results(the_class, name, conditions = nil)
    @terms = terms(params[:query])
    @query = params[:query]

    @result_set = the_class.find_with_index(@query, :limit => par("fulltext_results_limit"), :conditions => conditions)
    @result_set_formatted = []
    @result_set_name = name

    @max_default = par("fulltext_results_number")
    @max_extended = par("fulltext_results_number_extended")
    @max_total = @result_set.size
    
    render :partial => "results"
  end
  
  def results_articles
    load_results(Article, "articles", {:language_id => @current_language.id})
  end

  def results_headlines
    load_results(Headline, "headlines", {:language_id => @current_language.id})
  end

  def results_menu_items
    load_results(MenuItem, "menu_items", {:language_id => @current_language.id})
  end

  def results_media_albums
    load_results(MediaAlbum, "media_albums", {:language_id => @current_language.id})
  end

  def results_media_files
    load_results(MediaFile, "media_files", {:language_id => @current_language.id})
  end

  def results_evs_projects
    load_results(EvsProject, "evs_projects")
  end

  def results_ltv_projects
    load_results(LtvProject, "ltv_projects", {:language_id => @current_language.id})
  end

  def results_cz_projects
    load_results(CzProject, "cz_projects")
  end

  def search
    if params[:query]
      @render_results = true
      @query = params[:query]
    else
      redirect_to :action => :index
    end
  end

end
