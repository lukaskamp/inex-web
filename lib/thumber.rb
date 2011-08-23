module Thumber
  
  require 'RMagick'
  
  def self.make_thumbnail(image,w,h)
    if String === image
      image = Magick::Image.read(image).first
    end
    ww = image.columns
    hh = image.rows
    w2,h2 = if w == 0
              [ww.to_f/hh*h,h]
            elsif h == 0
              [w,hh.to_f/ww*w]
            elsif ww>hh
              [w,hh.to_f/ww*w]
            else
              [ww.to_f/hh*h,h]
            end
    w = w2 unless w > 0
    h = h2 unless h > 0
    thumb = Magick::Image::new(w,h){
        self.background_color = 'white'
      }
    small = image.thumbnail(w2,h2)
    thumb.composite!(small, Magick::CenterGravity, 0,0,  Magick::ReplaceCompositeOp)
    thumb
  end
  
end