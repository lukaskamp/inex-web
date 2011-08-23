require 'test/test_helper'

class EvsProjectsControllerTest < ActionController::TestCase

  # this controller does virtually nothing
  # the retrieval capabilities are tested in the unit
  
  def test_show
    for_all_users_and_langs do |lang|
      get :index, :language_code => lang, :active_menu_item => 0
      assert_response :success
    end
  end

end
