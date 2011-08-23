# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include LanguageAware
  include ParameterAware

  # Displays builtin text in current language. The parameters
  # are replaced unless empty.
  # TODO - move the parameter replacement to model!
  #
  # Editation link is returned if no text is found
  # and admin is logged in, or admin is logged in and
  # :edit_allowed option is true.
  def bt(name, options = {:edit_allowed => true, :display_name => true })
    text = BuiltinText.find_by_name(name,@current_language)
    body = text ? text.body : nil
    body = body.dup if body
    if options[:params] and body
      text.body = replace_params(body, options[:params] )
    end
    body

    # TODO - remove returns? simplify?
    if options[:edit_allowed] and admin_view?
      if text and text.body
        return builtin_text_edit_link(text)
      else
        return builtin_text_new_link(name)
      end
    else
      if text and text.body and (not text.body.empty?)
        if options[:display_name] and admin_view?
          return h(text.body) + " [#{name}]"
        else
          return h(text.body)
        end
      else
        unless options[:can_be_blank]
          return "(#{name})"
        else
          return ""
        end
      end
    end
  end

  def smart_article_url(article)
    if sa = article.special_article and sa.associated_controller
      url_for(:language_code => @current_language.code, :controller => sa.associated_controller, :action => (sa.associated_action||'index'))
    else
      article_path(lng(:url_atom => article.url_atom))
    end
  end

  def lng(hash, params={})
    hash[:language_code] = @current_language ? @current_language.code : params[:language_code]
    hash[:url_atom] ||= "_" if hash.keys.include? :url_atom
    hash[:id] = hash[:id].to_i.to_s if hash.keys.include? :id
    hash
  end

  def render_special_article(key)
    article = SpecialArticle.find_by_key(key, @current_language)
    if article
      '<div class="special_article_title">' + article.title + '</div>'+
      '<div class="special_article_body">' + article.body + '</div>'
    else
      "<p>Expecting special article <b>#{key}</b>!</p>"
    end
  end

  # Creates image with icon and optional label.
  # 'hint_only' toggles whether label is displayed next to icon, or just as hint.
  def icon(key, label = nil, hint_only = false)
    show_icon(par("#{key}_icon"), label, label || key, hint_only)
  end

  # Creates image with icon and optional label.
  # 'hint_only' toggles whether label is displayed next to icon, or just as hint.
  def show_icon(filename, label = nil, alt = nil, hint_only = false)
    tag = image_tag(filename, :class => "icon", :alt => alt, :title => alt )
    tag += " #{label}" if label and not hint_only
    tag
  end

  # Creates image with flag of passed Country or Language
  def flag(where)
    case where
        when Language
          alt = where.link_title
          translation_table = { 'cs' => 'cz', 'en' => 'gb' }
          file = translation_table[where.code] || where.code

        when Country
          alt = "#{where.code} - #{where.name}"
          file = where.code.downcase
    end

    image_tag("flags/#{file}.png", :class => "icon", :alt => alt, :title => alt )
  end

  def thumbnail_dimensions
    "#{par("thumbnail_x_size")}x#{par("thumbnail_y_size")}"
  end

  def photo_dimensions
    "#{par("photo_x_size")}x#{par("photo_y_size")}"
  end

  #
  # Just creates standard AS textarea and adds 'no_rich_text'
  # CSS class to it. It should be configurable
  # by config.columns[:...].css_class but it didn't work.
  #
  # Used to override ActiveScaffold textarea fields
  # that should contain plain text and not HTML.
  #
  def no_wysiwyg_text_area_tag(value, field_name)
    text_area_tag( field_name,
                   value,
                    :size => "50x10",
                    :class => 'no_rich_text body-input text-input')
  end

  def render_language_switcher
    other_languages = Language.find(:all).reject {|lang| lang == @current_language }
    links = []

    other_languages.each do |language|
      path = '/' + language.code + request.path[3,:end]
      links << link_to(language.to_label, path)
    end

    links
  end


  def stylesheet_links_for_controller
      controller_css = "#{@controller.controller_path}.css"
      path = "#{RAILS_ROOT}/public/stylesheets/#{controller_css}"
      stylesheet_link_tag(controller_css) if File.exists? path
  end

  private

# TODO - test and uncomment
#  # Climbs up in class hierarchy of the current controller,
#  # stopping at ApplicationController. If there is a related
#  # CSS file for some of the controllers, creates link to it.
#  def stylesheet_link_to_controller_css()
#    stylesheet_link_controller_hierarchy( @controller.class, "")
#  end
#
#  def stylesheet_link_controller_hierarchy( controller, result)
#      ancestor = controller.superclass
#
#      if ancestor != ApplicationController
#        result = "#{result} #{stylesheet_link_controller_hierarchy( ancestor, result)}"
#
#      end
#
#      controller_css = "#{controller.controller_path}.css"
#      path = "#{RAILS_ROOT}/public/stylesheets/#{controller_css}"
#      stylesheet_link_tag(controller_css) if File.exists? path
#  end


  # Replaces parameters in builtin text bodies.
  def replace_params(text, params)
    dest = text.dup
    params.each_with_index do |param,i|
      str_to_replace = '%' + (i+1).to_s
      dest.gsub!(str_to_replace, param)
    end
    dest
  end
  #FIXME - routes, routes, routes
  def builtin_text_edit_link(text)
    link =  ""
    link << text.body.dup if text.body
    link << " <a href=\""
    link << "/#{@current_language.code}/admin/builtin_text/edit/#{text.id}\">"
    link << icon('edit')
    link << "</a>"
    link
  end

  def builtin_text_new_link(name)
    link = "<a href=\""
    link << "/#{@current_language.code}/admin/builtin_text/new"
    link << "?name=#{name}\">"
    link << icon('edit')
    link <<  "Unknown text '#{name}'"
    link << "</a>"
    link
  end

end
