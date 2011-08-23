class Admin::HeadlineController < Admin::AdminController
  
  active_scaffold :headline do |config|
    config.columns[:title].required = true
    config.columns[:valid_from].required = true
    
    config.columns = [ :title, :valid_from, :valid_to, :article, 
                       :image_filename, :annotation_explicit,
                       :created_at, :created_by, :updated_at, :updated_by ]

    list.sorting = {:updated_at => 'DESC'}    
    list.columns = [:title, :annotation_explicit, :valid_from, :valid_to]
    config.show.link.label = 'Details'
                       
    exclude_user_cols_from_edit(config)                            
        
    config.columns[:annotation_explicit].label = 'Annotation'
    
    config.columns[:article].form_ui = :select
    config.columns[:article].options = { :include_blank => true }
    
    config.columns[:image_filename].form_ui = :select
  end

  prepare_image_filename_select
  
  # must be included after the 'active_scaffold' call to work
  include LanguageAware
  
  protected
   
  # ActiveScaffold callback to specify listing
  def conditions_for_collection
    ['headlines.language_id = ?', [ @current_language.id ]]
  end
   
  # ActiveScaffold callback for a prefilled headline creation
  def do_new
    super
    @record.valid_from = Time.now
    @record.valid_to = 1.weeks.from_now
    @record.title = params[:headline_title]
    @record.article_id = params[:headline_article]
    @image_filename_select_options = @@image_filename_select_options
  end
  
  def do_edit
    super
    @image_filename_select_options = @@image_filename_select_options
  end
  
end
