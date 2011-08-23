require 'test/test_helper'

class MenuEditingTest < ActionController::IntegrationTest
  fixtures :parameters, :users, :menu_items, :languages, :articles

  def setup
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_menu_editing
    admin = power_user
    admin.logs_in
    admin.synchronizes
    # verify that AS::new loads, ::create adds the item
    admin.adds_new_menu_on_top
    # verify that AS::edit loads and ::update edits the item; test this for Article and Album menuitem types
    # so that we are sure that the page loads
    admin.edits_the_first_item
  end

  def power_user
    open_session do |user|
      def user.logs_in
        get "/login"
        assert_response :success
        post_via_redirect "/session", {:login => "admin", :password => "test"}
        assert_response :success        
      end

      def user.synchronizes
        get_via_redirect "/cs/admin/media_gallery/sync"
        assert_response :success          
      end

      def user.adds_new_menu_on_top
        # load the index page
        get_via_redirect "/en/admin/menu_item/index"
        assert_response :success
        rmi = MenuItem.root_menu_items(languages(:english))
        assert_equal 2, rmi.size
        # load the 'new' page
        get_via_redirect "/en/admin/menu_item/new"
        assert_response :success
        # fill in the form and post
        post "/en/admin/menu_item/create", :record => {:url_atom => "my-plain-menu", :title => "My plain menu", :position => 1}
        assert_redirected_to "/en/admin/menu_item/index"
        follow_redirect!
        assert_response :success
        # load the root items again
        rmi = MenuItem.root_menu_items(languages(:english))
        assert_equal 3, rmi.size
        assert_equal "My plain menu", rmi.first.title
      end
      
      def user.edits_the_first_item
        # load the root items again
        rmi = MenuItem.root_menu_items(languages(:english))
        assert_equal 3, rmi.size
        assert_equal "My plain menu", rmi.first.title
        
        the_title = "My plain menu"
        
        [ \
          ["My album menu","MenuItemMediaAlbum",MenuItemMediaAlbum.targets_for_as(languages(:english)).size], \
          ["My article menu","MenuItemArticle",MenuItemArticle.targets_for_as(languages(:english)).size] \
        ].each do |title, type, target_count|
          # open the edit page
          get_via_redirect "/en/admin/menu_item/edit/#{rmi.first.id}"
          assert_equal the_title, assigns(:record)[:title]
          record = assigns(:record)
          # post the update
          post_via_redirect "/en/admin/menu_item/update/#{rmi.first.id}", :record => {:title => title , :type => type, :position => 1}
          assert_response :success
          # change tracked item title
          the_title = title
          # open the edit page
          get_via_redirect "/en/admin/menu_item/edit/#{rmi.first.id}"
          record = assigns(:record)
          assert_equal the_title, record.title
          # now we need to call the target_select ajax update
          xml_http_request(:get, "/en/admin/menu_item/reload_target?record=#{record.id}&type=#{record.type}")
          assert_response :success
          assert_equal target_count, (assigns(:target_options)||[]).size
          # load the root items again
          rmi = MenuItem.root_menu_items(languages(:english))
          assert_equal 3, rmi.size
          assert_equal the_title, rmi.first.title        
        end
      end

    end
  end
  
end

