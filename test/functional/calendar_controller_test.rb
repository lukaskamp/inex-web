require 'test/test_helper'

class CalendarControllerTest < ActionController::TestCase

  def test_index
     for_all_users_and_langs do |lang|
       get :index, :language_code => lang, :active_menu_item => 0
       assert_response :success
       assert_template 'index'
     end
  end
end
