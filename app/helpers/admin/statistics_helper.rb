module Admin::StatisticsHelper
   
  def chart_type_select()
    options = classes_to_options([ RatingChart, SummaryChart ])
    inside = select("chart", "type", options, :selected => @chart.type )
    simple_wrap 'Type', inside
  end    
  
  def field_select(chart)
    simple_wrap 'Question', select("chart", "field", extract_allowed_fields(chart))
  end

  def chart_term_select
    options = classes_to_options([ RecentYear, StaticTerm, FromXTillNow ])
    inside = select("chart[term]", "type", options)       
    simple_wrap 'Term', inside
  end
  
  def install_form_observer
    code = observe_form 'chart_form_id', 
                        :url => { :action => :render_chart }
    code                  
  end
  
  # TODO - move, rewrite, delete or whatever
  def chart_editor_style_adjust
    result =  "<style>"
    result << " table.form tr td { "
    result << "   width: 30%;"
    result << " }"
    result << "\n"
    result << " table.form tr td + td {"
    result << "   width: 70%;"
    result << " }"
    result <<  "</style>"
    result
  end
   
  private

  def extract_allowed_fields(chart)
    chart.allowed_fields.map do |field|
      [ bt("survey_field_#{field}", :edit_allowed => false, :display_name => false), field ]
    end
  end  
    
  def classes_to_options(classes)
    classes.map do |klass|
      [ ActiveSupport::Inflector.titleize(klass), klass.to_s]
    end    
  end
end