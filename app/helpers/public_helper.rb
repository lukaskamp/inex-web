module PublicHelper

  def menu_item_edit_link(id)
    menu_item = MenuItem.find(id)
    target_edit = menu_item.edit_target_url ? construct_url(menu_item.edit_target_url) : nil
    (create_edit_link('menu_item',id) || "") + ((target_edit and admin_view?) ? link_to(icon('edit_content'), target_edit) : "")
  end

  def special_article_edit_link(key)
    special_article = SpecialArticle.find_by_key(key, @current_language)
    create_edit_link('special_article', special_article.id, true) if special_article
  end

  def article_edit_link(id)
    create_edit_link('article',id)
  end

  def headline_edit_link(id)
    create_edit_link('headline',id)
  end

  def create_edit_link(type, id, alt_icon = false)
    link_to(icon(alt_icon ? 'edit_content' : 'edit'), "/#{@current_language.code}/admin/#{type}/edit/#{id}") if admin_view?
  end

  private :create_edit_link

  def headline_url(headline)
    if headline.article
      url_for(article_url(lng(:url_atom => headline.article.url_atom)))
    else
      url_for(root_url)
    end
  end

  def render_language_switcher(request)
    s = []
    Language.find(:all, :order => 'code').each do |lang|
      if lang == @current_language
        s << %{<span class="current_language">#{lang.code}</span>}
      else
        # this is ultra dirty
        # HACK HACK HACK
        clc = '/' + @current_language.code
        req = request.request_uri
        firstpart = request.protocol + request.host_with_port

        if req.include? firstpart
          address = req[firstpart.size .. -1]
        else
          address = req.dup
        end

        if address[0...clc.size] == clc
          url = '/' + lang.code + address[clc.size .. -1]
        else
          url = '/' + lang.code + address
        end

        # add parameter ... and once again, terrible hack
        # nfwarn instructs the path resolver not to raise "not found" warning
        # HACK HACK HACK
        unless url.include?("nfwarn=false")
          if url.include?('?')
            url << '&'
          else
            url << '?'
          end

          url << 'nfwarn=false'
        end

        # FIXME - pity it doesn't work anymore
        # url = url_for(:overwrite_params => {:language_code => lang.code})
        s << %{<span class="other_language">#{link_to lang.code, url}</span>}
      end
    end
    s*" / "
  end

  # Form with only one input, that changes its value on blur and focus.
  # Used for wiki search and email group subscription (right side of the main layout).
  # See _menu_right.html.erb
  def changing_input(input_name, label = nil)
    label ||= input_name.to_s
    text = bt(label, :allow_edit => false, :can_be_blank => true)
    selected_text = bt("#{label}_selected", {:allow_edit => false, :can_be_blank => true})

    text_field_tag( input_name, text,
                :onchange => "changing_input_onchange(this)",
                :onfocus => "changing_input_onfocus(this, '#{selected_text}')",
                :onblur => "changing_input_onblur(this,'#{text}')")
  end


  def linked_image_tag(filename, css_class = nil)
    # no magic! just - if the filename starts with an underscore, split it and use as a web address
    # _www_foo_bar.jpg => http://www.foo.bar
    if File::basename(filename)[0..0] == "_"
        link_to image_tag(filename, :class => css_class), "http://" + File::basename(filename).split(".")[0].split("_")[1..-1] * ".", :target => '_blank'
    else
      image_tag filename, :class => css_class
    end
  end

  def construct_url(options, parameters = {})
    opts = options.dup
    params = parameters.dup

    opts[:language_code] = @current_language.code
    opts[:url_atom] ||= "_" if opts.keys.include? :url_atom
    opts[:id] = opts[:id].to_i.to_s if opts.keys.include? :id

    menu = opts[:menu] || params[:menu]
    opts.delete(:menu)
    params.delete(:menu)

    if opts[:url_atom]
      return \
        "/#{opts[:language_code]}"+
        (menu ? ("/" + menu.url_atoms) : "") +
        "/#{opts[:url_atom]}"
    end

    opts.delete(:additional_parameters) if !opts[:additional_parameters] or opts.empty?

    url =
    if opts[:route]
      route_name = opts[:route]
      opts = opts.dup
      opts.delete(:route)
      opts.merge!(params)
      opts.keys.each{|k| opts[k] = opts[k].to_s if opts[k]}
      self.send("#{route_name}_path", opts)
    elsif !opts or !opts[:controller]
      url_for(:overwrite_params => params)
    else
      if par = opts[:additional_parameters]
        par.split("&").each do |s|
          foo = s.split("=")
          params[s[0]] = s[1] unless params[s[0]]
        end
      end

      params[:controller] = "#{opts[:controller]}"
      params[:action] = opts[:action]
      if menu and menu.url_atoms
        params[:path] = menu.url_atoms.split("/")
      end
      # if params[:id]
      #   connect_with_id_path params
      # elsif params[:action]
      #   connect_without_id_path params
      # else
      #   connect_without_action_path params
      # end
      url_for params
    end
    url
  end

  # def render_one_item( parent, can_edit)
  #   result = "<li id=\"menu_item_#{parent.id}\">"
  #
  #   link = construct_url(parent.target_url)
  #   edit_link = construct_url(parent.edit_target_url)
  #
  #   if link
  #     result << link_to_unless_current(parent.title, link, {:id => "menu_link_#{parent.id}"})
  #
  #     if can_edit and edit_link
  #       result << link_to(icon('edit_content'), edit_link)
  #     end
  #   else
  #     result << parent.title
  #   end
  #
  #   if can_edit
  #     result << link_to(icon('edit'), menu_item_edit_link(parent.id))
  #   end
  #
  #   unless parent.children.empty?
  #     result << '<ul>'
  #     parent.children.each do |item|
  #       result << render_one_item( item, can_edit)
  #     end
  #     result << '</ul>'
  #   end
  #
  #   result << '</li>'
  # end

end
