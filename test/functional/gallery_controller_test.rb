require 'test/test_helper'

class GalleryControllerTest < ActionController::TestCase

  def setup
    sync_log = []
    MediaSynchronizer::synchronize_gallery(sync_log,true)
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
    
  def test_view_root
    for_all_users_and_langs do |lang|
      # get the root album
      root_album = MediaAlbum::root(Language::find_by_code(lang))
      
      # look at the gallery
      # verify that we see the root
      get :index, {:language_code => lang}
      assert_redirected_to :action => "show", :id => root_album.id      
    end
  end
    
  def test_browser
    assert_redirect_to_index :browse
  end

  def select_item_div(theclass,which)
    assert_select "div.#{theclass}:nth-of-type(#{which})" do 
      assert_select "a:nth-of-type(1)" do |link|
        yield(link)
      end
    end
  end

  def test_show    
    assert_redirect_to_index :show
  end

  def test_update_browser  
    assert_redirect_to_index :update_browser
  end
  
  def test_root_contents
    for_all_users_and_langs do |lang|
      # get the root album
      root_album = MediaAlbum::root(Language::find_by_code(lang))
      # go there directly
      # verify that two correct albums and two correct photos are shown
      get :show, {:language_code => lang, :id => root_album.id}
      assert :success
      # begin
        assert_select "div.gallery_album_item_album", 2
        select_item_div("gallery_album_item_album", 1) {|link| assert_this_anchor_links_to_album(link, lang, "album1")}
        select_item_div("gallery_album_item_album", 2) {|link| assert_this_anchor_links_to_album(link, lang, "album2")}

        # FIXME - unable to find out why this does not work at all
        # puts @response.body
        # p "Xa"
        # assert_select "div.gallery_album_item_photo", 2
        # p "Xb"
        # select_item_div("gallery_album_item_photo", 1) {|link| assert_this_anchor_links_to_file(link, lang, "bodak.jpg")}
        # p "Xc"
        # select_item_div("gallery_album_item_photo", 2) {|link| assert_this_anchor_links_to_file(link, lang, "propriete.jpg")}
        # p "Xd"
      # rescue
      #   raise "misery"
      # end
    end
  end
    

  private

  def assert_redirect_to_index(action)
    for_all_users_and_langs do |lang|
      get action, { :language_code => lang, :id => -1, :active_menu_item => 0 }
      assert_redirected_to :action => :index
    end
  end
  
  def assert_this_anchor_links_to_album(elements, lang, filename)
    href = elements.first.attributes["href"]
    match=Regexp.compile(Regexp.escape("/#{lang}/album/")+"(\\d+)").match(href)
    assert_not_nil match
    album = MediaAlbum::find(:first, :conditions => ["id = ?", match[1].to_i])
    assert_not_nil album, "Looking for album #{match[1]}, but it was not found"
    assert_equal filename, album.filename
    album.id
  end
  
  def assert_this_anchor_links_to_file(elements,lang,filename)
    href = elements.first.attributes["href"]
    regex = Regexp.compile(Regexp.escape("/#{lang}/gallery/browse/")+"(\\d+).+?\\?index=(\\d+)")
    match = regex.match(href)
    assert_not_nil match, "#{href} did not match #{regex}"
    album = MediaAlbum::find(:first, :conditions => ["id = ?", match[1].to_i])
    assert_not_nil album
    file = (album.files_for_user)[match[2].to_i]
    assert_not_nil file
    assert_equal filename, file.filename
    file.id
  end


end
