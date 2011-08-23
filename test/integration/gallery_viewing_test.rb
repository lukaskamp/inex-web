require 'test/test_helper'

def extract_target_from_ajax_updater(script)
  match = /Ajax.Updater\('(.+?)',\s+'(.+?)'/.match script
  fail "Target not found in AJAX script: #{script}" unless match
  match[2]
end

class GalleryViewingTest < ActionController::IntegrationTest
  fixtures :parameters, :users

  def setup
    MediaSynchronizer::synchronize_gallery(log=[],true)
  end
  
  
  def test_gallery_browsing
    radka = regular_user
    radka.goes_to_gallery
    radka.sees_root
    radka.opens_first_album
    radka.checks_first_album_contents
    radka.plays_with_media_browser
    radka.goes_to_browser_and_back
  end

  protected

  def regular_user
    open_session do |user|
      
      def user.goes_to_gallery
        get_via_redirect '/cs/fn/gallery'
        assert_response :success
      end
      
      def user.sees_root
        @root = MediaAlbum::root(Language::find_by_code("cs"))
        assert_not_nil @response.template.assigns["album"], "No album assigned in the action"
        assert_equal @root.id, @response.template.assigns["album"].id, "Assigned album's ID is different from the root ID"
      end
      
      def user.opens_first_album
        @first_album = @response.template.assigns["sub_albums"].first
        # is the first sub-album album1 ?
        assert_equal "album1", @first_album.filename
        # go to the first album
        get album_path(:language_code => "cs", :id => @first_album.id, :active_menu_item => 0 )
        assert_response :success
      end
      
      def user.goes_to_browser_and_back
        get "/cs/fn/gallery/browse/#{@first_album.id}?index=0"
        assert_response :success
        href = nil
        assert_select "#gallery_album_title" do 
          assert_select "a:last-of-type" do |element|
            href = element.first.attributes["href"]
          end
        end
        get href
        assert_response :success
        assert_equal @first_album.id, assigns(:album).id
      end
      
      def user.checks_first_album_contents
        get album_path(:language_code => "cs", :id => @first_album.id, :active_menu_item => 0 )
        # are there no subalbums?
        assert_equal [], assigns(:sub_albums)
        # is the first subfile plot.jpg ? 
        assert_equal "plot.jpg", assigns(:sub_files).first.filename

        # are there two photos?
        assert_select "div.gallery_album_item_photo", :count => 2
        
        # look at the first one
        assert_select "div.gallery_album_item_photo:first-of-type" do
          # get the first's link
          assert_select "a" do |element|
            @first_href = element.first.attributes["href"]
            # inspect the first's image
            assert_select "img" do |element|
              # get the image id
              match = Regexp.new("/media/thumb/(\\d+)/").match(element.first.attributes["src"])
              image_id = match[1].to_i
              # does it point to plot?
              assert_equal "plot.jpg", MediaFile.find(image_id).filename
            end
          end
        end
                
      end
      
      def user.plays_with_media_browser
        get @first_href
        assert_equal 0, assigns(:index)
        assert_select "script#gallery_browser_loader" do |element|
          media_browser_script = element.first.to_s
          @media_browser_href = extract_target_from_ajax_updater(media_browser_script)
        end

        href = @media_browser_href
        
        xml_http_request(:get, href)
        assert_equal 0, assigns(:index)
        assert_select "div#gallery_browser_navigator_backward a", false
        assert_select "div#gallery_browser_navigator_forward a#gallery_browser_button_next" do |element|
          onclick = element.first.attributes["onclick"]
          href = extract_target_from_ajax_updater(onclick)
        end
        
        xml_http_request(:get, href)
        assert_equal 1, assigns(:index)
        assert_select "div#gallery_browser_navigator_forward a", false
        assert_select "div#gallery_browser_navigator_backward a#gallery_browser_button_previous" do |element|
          onclick = element.first.attributes["onclick"]
          href = extract_target_from_ajax_updater(onclick)
        end

        xml_http_request(:get, href)
        assert_equal 0, assigns(:index)
      end
      
    end
  end


end

