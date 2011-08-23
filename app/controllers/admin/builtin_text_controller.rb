class Admin::BuiltinTextController < Admin::AdminController
  
  active_scaffold :builtin_text do |config|
    config.label = "Texts"
    list.sorting = {:name => 'ASC'}
    
    config.create.link.label = "Add a text"
    config.columns = [ :name, :body, :alternates, :created_by, :updated_by ]
    config.show.columns = [:name, :body, :alternates, :created_at, :created_by, :updated_at, :updated_by]
    list.columns = [:name, :body]
    config.columns[:name].required = true
    config.columns[:body].label = 'Text body'
    
    exclude_user_cols_from_edit(config)                            
    config.update.columns.exclude :name
  end
  
  # must be included after the 'active_scaffold' call to work
  include LanguageAware
  
  # TODO - write a test for this behaviour
  def do_new
    super
    @record.name = params[:name] if params[:name]
  end
  
end
