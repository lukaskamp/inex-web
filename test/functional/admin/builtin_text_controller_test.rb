require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'
require 'test/functional/admin/authoring_fields_tester'

class Admin::BuiltinTextControllerTest < ActionController::TestCase
      
  def test_routing
    opts = { :language_code => "cs", :controller => "admin/builtin_text", :action => 'index' }
    assert_recognizes opts, "/cs/admin/builtin_text"
  end
  
  protected 
  
  def item
    builtin_texts(:en_vodka_fun)
  end

end
