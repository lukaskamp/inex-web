module Admin::LtvProjectsHelper

  def fulltext_form_column( record, field_name)
    no_wysiwyg_text_area_tag(record.fulltext, field_name) 
  end

end
