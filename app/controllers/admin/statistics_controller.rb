class Admin::StatisticsController < Admin::AdminController
  
  before_filter :construct_chart, :only => [ :render_chart, :save_chart ]
  
  # TODO - add created_by and updated_by
  active_scaffold :statistic_queries do |config|
    config.label = "Charts"
    list.sorting = { :updated_at => 'DESC'}    
    list.columns = [ :name, :field, :url_for_web, :term_in_human, :created_at ]

    action_link config, 'create_chart', 'Create Chart', 'admin_statistics'
    action_link config, 'survey', 'Survey Data', 'survey_data', :action => 'index', :controller => 'admin/survey'
    action_link config, 'view_chart', 'View Chart', 'admin_view_chart', :type => :record, :action => 'chart', :controller => '../public'
    
    [ :google_chart_url, :term_in_human, :created_by, 
      :updated_by, :url_for_web, :generated_at, :type, :term ].each do |field|
      config.update.columns.exclude field
      config.create.columns.exclude field
    end
    
    config.create.link = nil
  end
  
  # must be included after the 'active_scaffold' call to work
  include LanguageAware  

  def save_chart
    if @chart.save
      redirect_to :action => :list
    else
      flash[:notice] = 'Please submit a valid chart'
    end
  end  
  
  def create_chart
    #@chart = RatingChart.new
    @chart = SummaryChart.new
    @chart.refresh
  end     
 
  def render_chart
    @chart.refresh if @chart.valid?
  end
    
  protected
  
  def construct_chart
    klass = params[:chart][:type].constantize
    
    unless StatisticQuery.valid_subclass? klass
      raise "Invalid class #{klass} selected"
      logger.error "Invalid class #{params[:chart][:type]} selected - request hacking?"
    end      
        
    @chart = klass.new(params[:chart])            
  end
     
  # TODO - is there some better solution?
  # hack that overrides this method from LanguageAware 
  def conditions_for_collection
    []
  end
    
end
