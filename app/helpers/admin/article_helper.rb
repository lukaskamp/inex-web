module Admin::ArticleHelper
  
  def annotation_form_column( record, field_name)
    no_wysiwyg_text_area_tag( record.annotation, field_name) 
  end

  def body_column(record)
    truncate(strip_tags(record.body),90)
  end
  
  def annotation_column(record)
    truncate(strip_tags(record.annotation),90)
  end
  
end
