require 'test/test_helper'

class ImageryControllerTest < ActionController::TestCase

  def setup
    sync_log = []
    MediaSynchronizer::synchronize_gallery(sync_log,true)
  end

  def test_thumbs_in_root
    for_all_users_and_langs do |lang|
      root_album = MediaAlbum.root(Language.find_by_code(lang))
      root_album.files_for_user.each do |image|
        
        get :thumb, :id => image.id, :dims => "100x100"
        assert_redirected_to image.full_filename(100,100)
        assert_equal "/data/mediagallery/.100x100/#{image.filename}", image.full_filename(100,100)
        
        get :image, :id => image.id
        assert_redirected_to image.full_filename
        assert_equal "/data/mediagallery/#{image.filename}", image.full_filename
        
      end
    end
  end

  def test_covers_in_root
    for_all_users_and_langs do |lang|
      root_album = MediaAlbum.root(Language.find_by_code(lang))
      root_album.media_albums.each do |album|
        get :cover, :id => album.id, :dims => "100x100"
        assert_redirected_to album.thumb_filename(100,100)
        assert_equal "/data/mediagallery/#{album.filename}/.cover_100x100.jpg", album.thumb_filename(100,100)
      end
    end
  end

end
