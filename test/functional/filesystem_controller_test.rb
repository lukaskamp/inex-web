require 'test_helper'

class FilesystemControllerTest < ActionController::TestCase

  def test_attachment_list
    for_all_users_and_langs do |lang|
      get :attachments, :language_code => lang, :active_menu_item => 0
      assert_equal 2, assigns(:list).size
      assert_equal "trainspotting.pdf", assigns(:list)[1]
    end
  end

  def test_image_list
    for_all_users_and_langs do |lang|
      get :images, :language_code => lang, :active_menu_item => 0
      assert_equal 2, assigns(:list).size
      assert_equal "sub/cover.jpg", assigns(:list)[1]
    end
  end
end
