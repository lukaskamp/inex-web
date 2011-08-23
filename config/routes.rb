ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :session
  map.login  "/login", :controller => 'sessions', :action => 'new'
  map.logout "/logout", :controller => 'sessions', :action => 'destroy'

  # TODO - remove
  map.connect "/:language_code/maptest", :controller => "workcamps/search", :action => "map"

  regex_lang = /[a-z]{2,3}/
  regex_id = /\d+/
  req_id = {:language_code => regex_lang, :id => regex_id}
  req_lang = {:language_code => regex_lang}
  req_admin = {:controller => %r{admin/([a-z_]+)}, :language_code => regex_lang}
  req_admin_nested = {:controller => %r{admin/admin/([a-z_]+)}, :language_code => regex_lang}

  # ADMIN
  map.admin   "/:language_code/admin", :controller => "admin/admin", :requirements => req_lang
  map.connect "/:language_code/:controller/:action", :requirements => req_admin
  map.connect "/:language_code/:controller/:action/:id", :requirements => req_admin
  map.connect "/:language_code/:controller/:action/:id.:format", :requirements => req_admin
  map.connect "/:language_code/:controller/:action.:format", :requirements => req_admin
  # ADMIN NESTED
  map.connect "/:language_code/:controller/:action", :requirements => req_admin_nested
  map.connect "/:language_code/:controller/:action/:id", :requirements => req_admin_nested
  map.connect "/:language_code/:controller/:action/:id.:format", :requirements => req_admin_nested
  map.connect "/:language_code/:controller/:action.:format", :requirements => req_admin_nested

  # CZ project
  map.cz_projects "/:language_code/fn/cz_projects/:id", :controller => "cz_projects", :action => "show", :requirements => req_id

  # CONTROLLER / ACTION
  map.connect "/:language_code/fn/:controller/:action", :requirements => req_lang
  map.connect "/:language_code/fn/:controller/:action/:id", :requirements => req_lang
  map.connect "/:language_code/fn/:controller/:action/:id.:format", :requirements => req_lang
  map.connect "/:language_code/fn/:controller/:action.:format", :requirements => req_lang
  map.connect "/:language_code/fn/*path/:controller/:action", :requirements => req_lang
  map.connect "/:language_code/fn/*path/:controller/:action/:id", :requirements => req_lang
  map.connect "/:language_code/fn/*path/:controller/:action/:id.:format", :requirements => req_lang
  map.connect "/:language_code/fn/*path/:controller/:action.:format", :requirements => req_lang

  # SPECIALS
  map.filesystem '/:language_code/filesystem/:action', :controller => 'filesystem', :requirements => req_lang
  map.rcss '/:language_code/rcss/:rcssfile.css', :controller => 'rcss', :action => 'rcss', :requirements => req_lang
  map.atom '/:language_code/atom', :controller => "headline", :action => 'atom', :format => :atom, :requirements => req_lang
  map.rss  '/:language_code/rss' , :controller => "headline", :action => 'feed', :format => :xml, :requirements => req_lang

  # CONTENT
  map.album   "/:language_code/album/:id", :controller => "gallery", :action => "show", :requirements => req_id
  map.browser "/:language_code/browser/:id/:index", :action => "update_browser", :controller => "gallery", :requirements => req_id
  map.chart   "/:language_code/chart/:id", :controller => "public", :action => "chart", :requirements => req_id

  # IMAGES
  map.cover "/media/cover/:id/:dims.jpg", :controller => "imagery", :action => 'cover'
  map.thumb "/media/thumb/:id/:dims.jpg", :controller => "imagery", :action => 'thumb'
  map.media "/media/:id.jpg",             :controller => "imagery", :action => 'image'
  map.article_thumb "/media/article_thumb/:dims/*filename", :controller => "imagery", :action => 'article_thumb'
  map.article_image "/media/article_image/*filename",       :controller => "imagery", :action => 'article_image'

  # ROOT
  map.root :controller => 'headline', :language_code => 'cs', :path => ''
  map.home '/:language_code', :controller => 'headline', :path => '', :requirements => req_lang


  # PRETTY PATH
  map.lang_catcher '/:language_code/*path', :controller => 'public', :action => 'resolve_path', :requirements => req_lang

  # 404
  map.catcher '*path', :language_code => 'cs', :controller => 'public', :action => 'not_found'

  # NON-RECOGNIZABLE GENERATOR ROUTES
  map.article '/:language_code/:url_atom', :controller => 'public', :action => 'resolve_path'
  map.edit_article "/:language_code/admin/article/edit/:id", :controller => "admin/article", :action => "edit"
  map.edit_album "/:language_code/admin/media_gallery/edit/:id", :controller => "admin/media_gallery", :action => "edit"
  map.edit_file  "/:language_code/admin/media_gallery/edit_file/:id",  :controller => "admin/media_gallery", :action => "edit_file"

#  map.sort_workcamps '/:language_code/fn/workcamps/sort', :controller => 'workcamps/cart_handling', :action => 'sort_workcamps'
  map.add_country '/:language_code/fn/workcamps/cart_handling/sort_workcamps', :controller => 'workcamps/cart_handling', :action => 'sort_workcamps'
  map.add_country '/:language_code/fn/workcamps/cart_handling/add_country', :controller => 'workcamps/cart_handling', :action => 'add_country'
  map.remove_country '/:language_code/fn/workcamps/cart_handling/remove_country', :controller => 'workcamps/cart_handling', :action => 'remove_country'
  map.apply_form '/:language_code/fn/workcamps/apply_form', :controller => 'workcamps/apply_form'
  map.workcamp_search '/:language_code/fn/workcamps/search/:action', :controller => 'workcamps/search'

  map.ltv '/:language_code/fn/ltv', :controller => 'ltv', :requirements => req_lang
  map.evs '/:language_code/fn/evs', :controller => 'evs', :requirements => req_lang
  map.headlines '/:language_code', :controller => 'headline', :path => '', :requirements => req_lang

  # regex_menuitem = /\d+/
  # regex_lang = /[a-z]{2,3}/
  # regex_id = /\d+(-.*)?/
  # req_std = {:active_menu_item => regex_menuitem, :language_code => regex_lang, :id => regex_id}
  # req_plain = {:active_menu_item => regex_menuitem, :language_code => regex_lang}
  # req_nomenu = {:language_code => regex_lang, :id => regex_id}
  #
  # req_admin = {:controller => %r{admin/([a-z_]+)},:language_code => regex_lang}
  # req_admin_nest = {:controller => %r{admin/([a-z_]+)/([a-z_]+)},:language_code => regex_lang}
  #
  # # filesystem calls
  # map.connect '/:language_code/filesystem/:action', :controller => 'filesystem', :requirements => req_lang
  #
  # # R-CSS
  # map.connect '/:language_code/rcss/:rcssfile.css', :controller => 'rcss', :action => 'rcss'
  #
  # # different content
  # map.article "/:language_code/:active_menu_item/article/:id", :controller => "article", :action => "show", :requirements => req_std
  # map.album   "/:language_code/:active_menu_item/album/:id", :controller => "gallery", :action => "show", :requirements => req_std
  # map.browser "/:language_code/browser/:id/:index", :action => "update_browser", :controller => "gallery", :requirements => req_nomenu
  # map.chart "/:language_code/chart/:id", :controller => "public", :action => "chart", :requirements => req_nomenu
  #
  # # rss
  # map.atom '/:language_code/atom', :controller => "headline", :action => 'atom', :format => :atom
  # map.rss  '/:language_code/rss' , :controller => "headline", :action => 'feed', :format => :xml
  #
  # # survey CSV export
  # map.survey_csv  '/:language_code/admin/survey/surveys.csv' , :controller => "admin/survey", :action => 'surveys', :format => :csv
  #
  # # czech project categories
  # map.cz_projects "/:language_code/:active_menu_item/czech_workcamps/:id", :controller => "cz_projects", :action => "show", :requirements => req_std
  #
  # # rather global and maybe somehow useless routes
  # map.headlines '/:language_code/:active_menu_item/headlines', :controller => 'headline', :requirements => req_plain
  # map.ltv '/:language_code/:active_menu_item/ltv', :controller => 'ltv', :requirements => req_plain
  # map.evs '/:language_code/:active_menu_item/evs', :controller => 'evs', :requirements => req_plain
  #
  # # workcamps & cart handling
  # map.add_country '/:language_code/:active_menu_item/cart/add_country', :controller => 'workcamps/cart_handling', :action => 'add_country'
  # map.remove_country '/:language_code/:active_menu_item/cart/remove_country', :controller => 'workcamps/cart_handling', :action => 'remove_country'
  # map.apply_form '/:language_code/:active_menu_item/workcamps/apply', :controller => 'workcamps/apply_form'
  #
  # # image routes
  # map.cover "/media/cover/:id/:dims.jpg", :controller => "imagery", :action => 'cover'
  # map.thumb "/media/thumb/:id/:dims.jpg", :controller => "imagery", :action => 'thumb'
  # map.media "/media/:id.jpg",             :controller => "imagery", :action => 'image'
  # map.article_thumb "/media/article_thumb/:dims/*filename", :controller => "imagery", :action => 'article_thumb'
  # map.article_image "/media/article_image/*filename",       :controller => "imagery", :action => 'article_image'
  #
  # # AS editor routes
  # map.edit_article "/:language_code/edit_article/:id", :controller => "admin/article", :action => "edit", :requirements => req_admin
  #
  # # media gallery editing
  # map.edit_album "/:language_code/admin/edit_album/:id", :controller => "admin/media_gallery", :action => "edit"
  # map.edit_file  "/:language_code/admin/edit_file/:id",  :controller => "admin/media_gallery", :action => "edit_file"
  #
  # map.root :controller => 'headline', :language_code => 'cs', :active_menu_item => 0
  #
  # # different home routes
  # map.home           '/:language_code/public', :controller => 'headline', :active_menu_item => 0, :requirements => {:language_code => /[a-z]{2,3}/}
  # map.admin          '/:language_code/admin',  :controller => 'admin/admin', :requirements => {:language_code => /[a-z]{2,3}/}
  # map.home_explicit  '/:language_code', :controller => 'headline', :active_menu_item => 0, :requirements => {:language_code => /[a-z]{2,3}/}
  #
  # # low-level default routes (admin)
  # map.connect '/:language_code/:controller/:action', :requirements => req_admin
  # map.connect '/:language_code/:controller/:action/:id', :requirements => req_admin
  # map.connect '/:language_code/:controller/:action', :requirements => req_admin_nest
  # map.connect '/:language_code/:controller/:action.:format', :requirements => req_admin_nest
  # # low-level default routes (other)
  # map.connect '/:language_code/:active_menu_item/:controller/:action', :requirements => req_plain
  # map.connect '/:language_code/:active_menu_item/:controller/:action.:format', :requirements => req_plain
  # map.connect '/:language_code/:active_menu_item/:controller/:action/:id', :requirements => req_std
  # map.connect '/:language_code/:active_menu_item/:controller/:action/:id.:format', :requirements => req_std
  #
  # map.lang_catcher '/:language_code/*path', :controller => 'public', :action => 'not_found', :active_menu_item => 0
  # map.catcher '*path', :language_code => 'cs', :controller => 'public', :action => 'not_found', :active_menu_item => 0
end
