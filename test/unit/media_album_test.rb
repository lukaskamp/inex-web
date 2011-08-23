require File.dirname(__FILE__) + '/../test_helper'

class MediaAlbumTest < ActiveSupport::TestCase

  def test_create_root
    lang = languages(:english)
    
    root = MediaAlbum.root(lang)
    assert_not_nil root, "Root not found for #{lang}"

    MediaAlbum.create_root(lang)
    new_root = MediaAlbum.root(lang)
    assert_equal new_root, root, "Root changed for #{lang}"

    roots = MediaAlbum.find(:all, :conditions => ["media_album_id IS NULL AND language_id = ?", lang.id])
    assert_equal 1, roots.size, "Too many roots for #{lang}"
  end

  def test_root
    MediaSynchronizer::synchronize_gallery(log=[],false)
    Language.find(:all).each do |lang|
      root = MediaAlbum.root(lang)
      assert_not_nil root, "Root not found for #{lang}"
      assert_nil root.parent, "Root has parent for #{lang}"
    end
  end
  
  def test_paths
    assert_equal "/data/mediagallery/album1/.cover_100x200.jpg", media_albums(:en_album1).thumb_filename(100,200), "Bad cover filename"
    assert_equal "/data/mediagallery/album1", media_albums(:en_album1).full_path, "Bad album full path"
    assert_equal "#{RAILS_ROOT}/test/fixtures/data/mediagallery/album1", media_albums(:en_album1).absolute_path, "Bad album abs-path"
  end
  
  def test_sub_items
    assert_equal media_albums(:en_root, :en_album1, :en_album2).to_set,
      languages(:english).media_albums.to_set, "Album association is wrong"
    assert_equal media_files(:en_bodak, :en_propriete, :en_invalid).to_set,
      media_albums(:en_root).media_files.to_set, "File association is wrong"
  end
  
  def test_subnames
    MediaSynchronizer::synchronize_gallery(log=[],false)
    Language.find(:all).each do |lang|
      assert_equal ["album1", "album2"], MediaAlbum.root(lang).sub_dir_names, "Bad album directories listed"
      assert_equal ["bodak.jpg", "propriete.jpg"], MediaAlbum.root(lang).sub_file_names, "Bad media files listed"
    end
  end
    
  def test_fix_positions
    plot_id = media_files(:en_plot).id
    propriete_id = media_files(:en_propriete).id
    assert_equal 1, MediaFile.find(plot_id).position
    assert_equal 2, MediaFile.find(propriete_id).position
    media_albums(:en_root).fix_positions(false)
    assert_equal 1, MediaFile.find(plot_id).position
    assert_equal 20, MediaFile.find(propriete_id).position
    media_albums(:en_root).fix_positions(true)
    assert_equal 10, MediaFile.find(plot_id).position
    assert_equal 20, MediaFile.find(propriete_id).position
  end
  
  def test_relations_and_synchronization
    root = MediaAlbum.root(languages(:english))
    assert_equal media_albums(:en_root), root, "Incorrect root"
    assert_equal 3, root.media_files.size, "Incorrect no. of files in root before sync"
    MediaSynchronizer::synchronize_gallery(log=[],false)
    assert_equal media_albums(:en_album1, :en_album2).to_set, root.media_albums.to_set, "Bad albums in en root"
    assert_equal media_files(:en_bodak, :en_propriete).to_set, root.media_files.to_set, "Bad files in en root"
    assert_equal media_files(:en_bodak, :en_propriete).to_set, root.files_for_admin.to_set, "Bad admin-visible files in en root"
    assert_equal [media_files(:en_bodak)], root.files_for_user, "Bad user-visible files in en root"
  end

end
