require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'
require 'test/functional/admin/authoring_fields_tester'

class Admin::ArticleControllerTest < ActionController::TestCase
  
  include Admin::ActiveScaffoldCRUDTester
  include Admin::AuthoringFieldsTester  
    
  def test_routing
    opts = { :language_code => "cs", :controller => "admin/article", :action => 'index' }
    assert_recognizes opts, "/cs/admin/article"
  end
  
  def test_edit
    get :edit, :language_code => "cs", :id => articles(:psi).id
  end
  
protected 
  
  def item
    articles(:psi)
  end

end
