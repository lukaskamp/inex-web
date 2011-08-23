module InexFormHelper
  
  def form_head(label, css_class = 'survey_head')
    result =  "<tr class=\"#{css_class}\">"
    result << " <td colspan=\"2\" class=\"#{css_class}\">#{label}</td>"
    result << "</tr>"
  end
  
  def form_subhead(label, css_class = 'survey_subhead')
    result =  "<tr class=\"#{css_class}\">"
    result << " <td colspan=\"2\" class=\"#{css_class}\">#{label}</td>"
    result << "</tr>"
    result
  end 
  
  def form_submit(f,label)
    result =  "<tr>"
    result << " <td/>"
    result << " <td>#{f.submit label}</td>"
    result << "</tr>"
    result
  end

  def form_text_area( f, field, label, options = {})
    wrap_in_table_row(f, field, label, f.text_area(field, {:size=>"40x8"}), options)
  end
  
  def form_text_field( f, field, label, options = {})
    wrap_in_table_row(f, field, label, f.text_field(field), options)
  end

  
  def form_select( f, field, label, options = {})
    choices = options[:collection]
    # TODO - replace 'nil' with method choosing pre-selected item
    select_tag = collection_select(field, nil, choices, :id, :to_label )
    wrap_in_table_row(f, field, label, select_tag, options)
  end
  
  def form_date_field( f, model_name, field_name, label, options = {})    
    calendar_picker = date_field( model_name, field_name, :value => options[:value])
    wrap_in_table_row(f, field_name, label, calendar_picker, options)
  end
  
  def form_radio( f, field, label, options, adlib_field = nil, adlib_label = nil )
    render :partial => 'shared/form_radio', 
      :locals => {  :f => f, 
      :field => field, 
      :label => label, 
      :options => options, 
      :adlib_field => adlib_field, 
      :adlib_label => adlib_label }
  end
  
  def form_yes_no( f, field, label )
    form_radio( f, field, label, [ 1, 0] )
  end
  
  def simple_wrap( label, inside, tr_class = nil)
    result =  "<tr#{tr_class ? " class=\"#{tr_class}\"" : ""}>"
    result << " <td><label>#{label}</label></td>"      
    result << " <td>#{block_given? ? yield : inside}</td>"
    result << '</tr>'
    result
  end  
  
  protected
  
  def wrap_in_table_row(f,field,label,inside, options = {})
    if options[:required]
      html_options = { :class => 'required' }
    else
      html_options = {}
    end
    
    result =  "<tr#{options[:tr_class] ? " class=\"#{options[:tr_class]}\"" : ""}>"
    result << " <td>#{f.label(field, label, html_options)}</td>"      
    result << " <td>#{inside}</td>"
    result << '</tr>'    
    result
  end
  
end