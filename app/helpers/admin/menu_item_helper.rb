module Admin::MenuItemHelper

  def render_breadcrumb(language, item)
    items = render_breadcrumb_element(language,item,[])
    items << "<a href=\"/#{language.code}/admin/menu_item\">Main Menu</a>"
    items.reverse.join(' > ')
  end

  def js_for_update(item)
    "t=$('record_type_#{@record.id}').value;"+
    "new Ajax.Updater("+
      "'record_#{item}_#{@record.id}', "+
      "'/#{@current_language.code}/admin/menu_item/reload_#{item}?record=#{@record.id}&type='+t, "+
      "{evalScripts: true, asynchronous:true, method: 'get'})"
  end

  def render_void
    "<dl><dt></dt><dd></dd></dl>"
  end

  def render_textedit(item, description=nil)
    "<dl>"+
      "<dt>"+
        "<label for=\"record_#{item}\">#{description||item}</label>"+
      "</dt>"+
      "<dd>"+
        "<input type=\"text\" value=\"#{@record[item]}\" size=\"30\" name=\"record[#{item}]\" "+
        "id=\"record_#{item}_input_#{@record.id}\" class=\"#{item}-input text-input\" autocomplete=\"off\"/>"+
      "</dd>"+
    "</dl>"
  end

  private

  # TODO - test
  def render_breadcrumb_element(language, item, result)
    action = "/#{language.code}/admin/menu_item/list?parent_id=#{item.id}"
    result << "<a href=\"#{action}\" >#{item.title}</a>"
    render_breadcrumb_element(language, item.parent, result) unless item.parent.nil?
    result
  end

end
