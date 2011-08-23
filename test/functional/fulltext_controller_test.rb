require 'test/test_helper'
require 'ftools'

class FulltextControllerTest < ActionController::TestCase
  
  include LanguageAware
  
  def setup
    FileUtils::rm_rf("#{RAILS_ROOT}/index/test")
  end
  
  def test_index
    [ 'en', 'cs' ].each do |code|
      get 'index', { :language_code => code, :active_menu_item => 0 }
      assert_response :success
      assert_template 'index'
      assert_select 'input[name=?]', 'query'
    end
  end
    
  def test_search_dogs
    assert_found_only('dogs', :articles)
  end
  
  def test_search_vegetables
    assert_found_only('vegetables', :menu_items)
  end
  
  # def test_search_album
  #   assert_found_only('album', 'media_albums')
  # end
  # 
  # def test_search_bodak
  #   assert_found_only('bodak', 'media_files')
  # end
  # TODO - also evs, ltv, cz here
  
  def test_search_lhota
    assert_found_only('lhota', :cz_projects)
  end
  
  def test_search_burkina
    assert_found_only('burkina', :ltv_projects)
  end
  
  def assert_found_only(what, where)
    targets = [:articles, :menu_items, :media_albums, :media_files, :ltv_projects, :cz_projects, :evs_projects]
    assert_found_once(what, where)
    (targets-[where]).each { |t| assert_not_found(what, t) }
  end

  def assert_not_found(what, where)
    get "results_#{where}", :query => what, :language_code => 'en', :active_menu_item => 0
    assert_response :success
    assert_template '_results'
    assert_select "p#fulltext_result_#{where}_1", false
  end
  
  def assert_found_once(what, where)
    get "results_#{where}", :query => what, :language_code => 'en', :active_menu_item => 0
    assert_response :success
    assert_template '_results'
    assert_select "p#fulltext_result_#{where}_1"
    assert_select "p#fulltext_result_#{where}_2", false
  end
  
  def test_routing  
    opts = { :language_code => 'cs', :controller => 'fulltext', :action => 'search' }
    assert_recognizes opts, '/cs/fn/fulltext/search'
  end
  
end
