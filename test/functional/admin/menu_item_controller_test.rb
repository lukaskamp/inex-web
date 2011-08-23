require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'

class Admin::MenuItemControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldCRUDTester
    
  protected 
  
  # for AS CRUDtester
  def item
    menu_items(:grocery)
  end
  
end
