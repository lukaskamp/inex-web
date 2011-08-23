class MediaFileImage < MediaFile

  belongs_to :media_album  

  def displayable?
    true
  end

  def browser_name
    "browser_image"
  end
  
  def thumbnail?(w,h)
    File.exists? absolute_filename(w, h)
  end

  def thumbnail!(w,h)
    return if File.exists? absolute_filename(w, h)
    thumb = Thumber::make_thumbnail(absolute_filename, w, h)
    File::makedirs(media_album.absolute_path(w, h))
    thumb.write(absolute_filename(w, h))
  end

end