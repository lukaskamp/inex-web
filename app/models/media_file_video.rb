class MediaFileVideo < MediaFile

  belongs_to :media_album  
  belongs_to :cover_image, :class_name => "MediaFile", :foreign_key => "linked_file"
  validates_presence_of :video_width, :video_height
  validates_numericality_of :video_width, :greater_than => 0
  validates_numericality_of :video_height, :greater_than => 0

  def browser_name
#    "browser_wmplayer"
    "browser_divxplayer"
  end    
  
  def image_file
    cover_image || self
  end

  def full_filename(w=nil,h=nil)
    if w and h
      media_album.full_path(w,h) + "/" + cover_image.filename
    else
      media_album.full_path + "/" + filename
    end
  end
  
  def displayable?
    true
  end
  
  def hidden?
    (self.hidden and self.hidden>0) or not (video_width and video_height and video_width > 0 and video_height > 0)
  end
  
  def thumbnail!(w,h)
    return if File.exists? absolute_filename(w, h)
    
    thumb = Thumber::make_thumbnail(cover_image.absolute_filename, w, h)
    icon = Magick::Image.read(RAILS_ROOT + par("video_icon_filename")).first
    thumb.composite!(icon, Magick::CenterGravity, w*0.3, h*0.3,  Magick::ReplaceCompositeOp)
    
    File::makedirs(media_album.absolute_path(w, h))
    thumb.write(absolute_filename(w, h))
  end
  
end