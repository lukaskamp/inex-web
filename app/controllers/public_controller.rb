class PublicController < ApplicationController

  include LanguageAware
  include InexHelpers

  layout "public"

  before_filter :switch_view
  before_filter :load_menu_chain, :except => :resolve_path

  # TODO - limit to POST requests
  def switch_view
    if params[:to_user_view]
      admin_view(false)
      redirect_to :back
    elsif params[:to_admin_view]
      admin_view(true)
      redirect_to :back
    else
      admin_view(:default) unless session[:show_admin_view]
    end
  end

  def not_found
    not_found_redirect
  end

  def load_menu_chain
    if params[:path] and params[:path] == ""
      @active_menu_item = nil
      session[:active_menu_item] = nil
    end

    unless params[:path]
      the_controller = self.controller_name
      the_action = self.action_name
      the_action = nil if the_action == 'index'
      @active_menu_item = MenuItemAction.first(:conditions => {:target_controller => the_controller, :target_action => the_action})
    end
    
    unless params[:path].blank?
      atoms = params[:path].split("/").flatten
      resolvable = true
      if atoms.size > 0
        menu_chain = atoms[0..-1].map{|a|
            item = MenuItem.find_by_url_atom(a, :conditions => {:language_id => @current_language.id})
            resolvable = false unless item
            item
          }.flatten
        @active_menu_item = menu_chain[-1] if resolvable
      end
    end

    @active_menu_item ||=
      if session[:active_menu_item]
        MenuItem.first(:conditions => {:id => session[:active_menu_item]})
      else
        nil
      end

    if @active_menu_item and (@active_menu_item.language_id != @current_language.id)
      @active_menu_item = nil
    end

    @active_menu_first = nil
    @active_menu_second = nil

    if @active_menu_item
      chain = ([@active_menu_item] + @active_menu_item.ancestors).flatten.reverse.compact
      @active_menu_first = chain[0]
      @active_menu_second = chain[1] if chain.size > 0
      session[:active_menu_item] = @active_menu_item.id
    else
      @active_menu_first = nil
      @active_menu_second = nil
      session[:active_menu_item] = nil
    end
  end

  def resolve_path
    # warn when page is not found?
    warn = (params[:nfwarn] != 'false')
    atoms = params[:path].split("/").flatten

    @article = Article.find_by_url_atom(atoms.last, :conditions => {:language_id => @current_language.id}) 
    unless @article
      articles = Article.find_all_by_url_atom(atoms.last)
      articles.map! { |a| a.language_version(@current_language) }
      articles.compact!
      @article = articles.first  
      atoms = [@article.url_atom] if @article
    end
    not_found_redirect(warn) and return unless @article

    if atoms.size > 1
      menu_chain = atoms[0...-1].map{|a|
          item = MenuItem.find_by_url_atom(a)
          not_found_redirect(warn) and return unless item
          item
        }.flatten
      @active_menu_item = menu_chain[-1]
    else
      # try to look up the article
      @active_menu_item = MenuItemArticle.first(:conditions => {:language_id => @current_language.id, :target_id => @article.id})
    end

    load_menu_chain

    render :action => :article
  end

  def chart
    loaded_chart = StatisticQuery.find(params[:id])
    redirect_to loaded_chart.google_chart_url
  end

  def newsletter_subscribe
    begin
      email = params[:email]
      TMail::Address.parse(email)
      NewsletterAdmin::subscribe(email)
      redirect_to :action => :newsletter_success
    rescue TMail::SyntaxError
      redirect_to :action => :newsletter_failure
    end
  end

  def newsletter_failure
  end

  def newsletter_success
  end

protected

  def article
  end

private

  def redirect_to_language_root
    redirect_to home_path(:language_code => @current_language.code)
  end

end

# kus byvaleho layoutu, srry
#
# <div id="menu">
#   <%= render_html_menu :can_edit => admin_view? %>
#   <center>
#     <%= render_language_switcher %>
#   </center>
#   <%= render :partial => 'public/subscribe' %>
# </div>
#
# <div id="content">
#   <%= render :partial => 'shared/infobox' %>
#   <%= yield %>
# </div>
#
# <%= javascript_include_tag "http://inex.uservoice.com/pages/web_user_features/widgets/tab.js?alignment=left&amp;color=E6F2FF" %>

