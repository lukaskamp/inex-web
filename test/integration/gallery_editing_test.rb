require 'test/test_helper'

class GalleryEditingTest < ActionController::IntegrationTest
  fixtures :parameters, :users

  def setup
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_edit
    radka = regular_user
    radka.goes_to_admin_gallery
    
    kuba = power_user
    kuba.logs_in
    kuba.goes_to_admin_gallery
    kuba.synchronizes
    kuba.goes_to_admin_gallery
    kuba.edits_root
    kuba.renames_first_album
  end
  
  private

  def regular_user
    open_session do |user|
      
      def user.goes_to_admin_gallery
        get "/cs/admin/media_gallery"
        assert_redirected_to :controller => "sessions", :action => "new"
      end
      
      def user.goes_to_gallery
        get_via_redirect "/cs/fn/gallery"
        assert_response :success
      end
      
    end
  end
  
  def power_user
    open_session do |user|
      def user.logs_in
        get "/login"
        assert_response :success
        post_via_redirect "/session", {:login => "admin", :password => "test"}
        assert_response :success        
      end

      def user.goes_to_admin_gallery
        get "/cs/admin/media_gallery"
        assert_response :success
      end
      
      def user.synchronizes
        get_via_redirect "/cs/admin/media_gallery/sync"
        assert_response :success          
      end
      
      def user.edits_root
        get_via_redirect "/cs/admin/media_gallery"
        assert_response :success
        assert_select "div#content a:nth-of-type(2)" do |link|
          @edit_href = link.first.attributes["href"]
        end
      end
      
      def user.renames_first_album
        get @edit_href
        assert_response :success
        edit_action, item_id = nil, nil
        assert_select "div.album_photo:nth-of-type(1)" do 
          assert_select "form" do |element|
            edit_action = element.first.attributes["action"]
            element.first.attributes["id"] =~ /media_album_(\d+)/
            item_id = $1.to_i
            assert item_id > 0
          end
        end
        post_via_redirect edit_action, :media_album => {:id => item_id, :title => "New title"}
        assert_response :success
      end
    end
  end

end