module MediaSynchronizer

  def self.synchronize_gallery(log,force)
    if force
      MediaAlbum.delete_all
      MediaFile.delete_all
      log << [:force, "switched on"]
    end
    Language.find(:all).each do |lang|
      # create root if it doesn't exist
      MediaAlbum.create_root(lang)
      synchronize_album(MediaAlbum.root(lang),log)
    end
    link_videos_to_images(log)
    fix_positions
  end
  
  def self.fix_positions
    Language.find(:all).each do |lang|
      MediaAlbum.root(lang).fix_positions
    end
  end
  
private
  
  def self.link_videos_to_images(log = [])
    MediaFileVideo.find(:all).each do |video|
      base = File::basename(video.filename, File::extname(video.filename))
      images = MediaFileImage.find(:all, :conditions => ["media_album_id = ?", video.media_album_id])
      related = images.select{|img| File::basename(img.filename,File::extname(img.filename)) == base}
      if related.size == 1
        log << [:linked_video, base]
        image = related.first
        image.virtual = 1
        image.save!
        video.linked_file = image.id
        video.save(false)
      end
    end
  end
  
  def self.synchronize_album(album, log = [])
    log << [:album_process, album.title || "" + "(" + album.absolute_path + ")" + "{" + album.language.code + "}"]

    remove_invalid_sub_items(album, log, album.media_albums, album.sub_dir_names, MediaAlbum)
    remove_invalid_sub_items(album, log, album.media_files, album.sub_file_names, MediaFile)

    add_new_files(album, log)
    add_new_albums(album, log)
    
    album.media_albums(true).each{|a| synchronize_album(a, log)}
  end

  def self.add_new_files(album,log)
    to_add = album.sub_file_names.reject do |filesystem_file_name|
      album.media_files.detect{|sub_file| sub_file.filename == filesystem_file_name}
    end
    to_add.each_with_index do |fn, i|
      ext = File::extname(fn)
      lext = ext.downcase
      if (ext != lext)             
        lfn = fn.sub(Regexp.compile(ext+'$'), lext)
        log << [:rename_file, "#{fn} to #{lfn}"]
        File::rename(
          File::join(RAILS_ROOT, 'public', album.full_path, fn), 
          File::join(RAILS_ROOT, 'public', album.full_path, lfn) )
        fn = lfn
      end
      case fn
        when /\.jpg$/, /\.png$/, /\.gif$/
          f = MediaFileImage.new
        when /\.divx/, /\.avi$/, /\.mov$/, /\.wmv/, /\.qt/, /\.mpg$/, /\.mpeg$/
          f = MediaFileVideo.new
        else
          f = nil
      end        
      if f
        log << [:add_file, fn + "(#{f.class})"]
        f.filename = fn
        f.media_album = album
        f.position = 10*(i-1-to_add.size)
        f.save(false)
      else
        log << [:unknown_file_type, fn]
      end
    end
  end
  
  def self.add_new_albums(album,log)
    to_add=album.sub_dir_names.reject do |filesystem_dir_name|
      album.media_albums.detect{|sub_album| sub_album.filename == filesystem_dir_name}
    end
    to_add.each_with_index do |fn,i|
      log << [:add_album, fn]
      a = MediaAlbum.new  :filename => fn,
                          :media_album_id => album.id,
                          :language_id => album.language_id,
                          :position => 10*(i-1-to_add.size)
      a.save
    end
  end

  def self.remove_invalid_sub_items(album,log,items,filenames,item_class)
    to_delete = items.reject do |x| 
                  filenames.include? x.filename
                end
                
    if to_delete.size > 0
      to_delete.each do |item| 
        log << [:remove_invalid, item.filename]
        item_class.delete(item.id)
      end
    end
  end

end