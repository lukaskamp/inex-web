class MediaFileYoutube < MediaFile

  belongs_to :media_album  

  validates_presence_of :video_width, :video_height
  validates_numericality_of :video_width, :greater_than => 0
  validates_numericality_of :video_height, :greater_than => 0

  def browser_name
    "browser_youtube"
  end

  def displayable?
    true
  end

  def thumbnail!(w,h)
    return if File.exists? absolute_filename(w, h)
    
    thumb = Thumber::make_thumbnail(absolute_filename, w, h)
    icon = Magick::Image.read(RAILS_ROOT + par("video_icon_filename")).first
    thumb.composite!(icon, Magick::CenterGravity, w*0.3, h*0.3,  Magick::ReplaceCompositeOp)
    
    File::makedirs(media_album.absolute_path(w, h))
    thumb.write(absolute_filename(w, h))
  end

end