class Admin::ParameterController < Admin::AdminController
  
  include LanguageAware
  before_filter :set_description, :only => [ :edit ]
 
  
  active_scaffold :parameters do |config|
        
    config.columns = [ :key, :type, :get_value, :value, :description, :created_by, :updated_by ]
    list.columns =   [ :key, :type, :get_value, :description ]
    list.sorting =   [ :key ]


    exclude_user_cols_from_edit(config)
    config.update.columns.exclude :key, :type, :description, :get_value
    config.show.columns.exclude :value
    config.actions.exclude :create, :delete

    config.columns[:get_value].label = 'Value'
    config.columns[:type].form_ui = :select
    config.columns[:type].options = { "Integer number" => "IntegerParameter",
                                      "Real number" => "FloatParameter",
                                      "Date" => "DateParameter",                                      
                                      "Text" => "StringParameter"}
  end
  
  def edit_by_key
    parameter = Parameter.find_by_key(params[:code])
    # TODO - use named route
    redirect_to :action => :edit, :id => parameter.id, :language_code => @current_language.code
  end
  
  # TODO - rather inject this method
  def before_create_save(record)
    record.created_by = current_user
  end

  # TODO - rather inject this method
  def before_update_save(record)
    record.updated_by = current_user
  end
  
  def conditions_for_collection
    condition = "key NOT LIKE '%_icon'"
  end
  
protected

  def set_description
    if params[:id]
      active_scaffold_config.columns[:value].description = Parameter.find(params[:id]).description
    end
  end


  def key_ok?
    (params[:record][:key]) !~ /_icon$/
  end
  
  def why_not_like_key
    "has an icon suffix"
  end

  def do_update
    @record = Parameter.find(params[:id])
    key_ok? ? super : @record.errors.add("Key", why_not_like_key)
  end
  
  def do_create
    @record = Parameter.find(params[:id])
    key_ok? ? super : @record.errors.add("Key", why_not_like_key)
  end

  def update_authorized?
    current_user.admin?
  end

  def edit_authorized?
    current_user.admin?
  end

end
