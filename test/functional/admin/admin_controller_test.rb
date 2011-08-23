require 'test/test_helper'

class Admin::AdminControllerTest < ActionController::TestCase
  
  def setup
    login_as 'admin'
  end
  
  def tear_down
    logout
  end
  
  def test_switch_advanced_menu
    xhr :post, :switch_advanced_menu, :language_code => 'cs'
    assert_response :success
    # TODO - assert user's setting are toggled
    # TODO - assert it shows the menu - assert_select_rjs :replace_html, :advanced_menu_items
  end
  
end