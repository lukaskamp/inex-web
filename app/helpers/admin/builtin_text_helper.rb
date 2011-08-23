module Admin::BuiltinTextHelper
  
  def included(base)
    logger.debug "Admin::BuiltinTextHelper included into #{base}"
  end
  
  def body_form_column(record, field_name)    
    # The condition is a workaround for AS bug. 
    # It cripples the ArticleController edit view (body)
    # with this column definition otherwise, since they
    # the Article has an attribute with the same name.
    #
    # TODO - file the bug to AS and remove this hack
    #
    unless record.class == Article
      no_wysiwyg_text_area_tag(record.body, field_name)
    else
      text_area_tag( field_name, 
                     record.body,
                    :size => '50x30',
                    :class => 'body-input text-input')
    end
  end
  
  def alternates_form_column(record, field_name)
    alternates_column(record)
  end
  
  def alternates_column(record)
    s = ""
    record.other_language_versions.each do |code,text|
      s << "<p>[#{code}]: #{text}</p>"
    end
    s
  end
  
end