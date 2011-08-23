module Admin::HeadlineHelper

  def annotation_explicit_form_column(record, field_name)
    no_wysiwyg_text_area_tag(record.annotation_explicit, field_name)
  end

  def annotation_explicit_column(record)
    truncate(record.annotation,100)
  end

  def image_filename_form_column(record, field_name)
    s = %{<select name="#{field_name}" id="#{field_name}" class="image_filename-input">}
    for key,value in (@image_filename_select_options||[])
      s << %{<option value="#{value}" #{'selected="selected"' if value == @record.image_filename}>#{key}</option>}
    end
    s << %{</select>}
    s << "\n\n"
    s << %{<div style="float:left;margin-top:10px;max-width:500px;">}
    for key,value in (@image_filename_select_options||[])
      if value
        s << image_tag( #article_thumb_url(:dims => "#{par("editor_thumbnail_size")}x#{par("editor_thumbnail_size")}", :filename => value),
                       # HACK - TODO - udelat lepe
                        "/media/article_thumb/#{par('editor_thumbnail_size')}x#{par('editor_thumbnail_size')}/#{value}",
                        :onClick => "$('#{field_name}').value='#{value}'")
      end
    end
    s << %{</div>}
  end

end
