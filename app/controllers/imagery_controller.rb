require 'rubygems'
require 'RMagick'

class ImageryController < ApplicationController    
    
  def cover
    m=(/(\d+)x(\d+)/.match(params[:dims]))
    w,h=m[1].to_i,m[2].to_i
    @album = MediaAlbum.find(params[:id])
    @album.thumbnail(w,h)
    redirect_to @album.thumb_filename(w,h)
  end
  
  def image
    @image = MediaFile.find(params[:id])
    redirect_to @image.full_filename
  end
  
  def thumb
    @image = MediaFile.find(params[:id])
    m=(/(\d+)x(\d+)/.match(params[:dims]))
    w,h=m[1].to_i,m[2].to_i
    @image.thumbnail!(w,h)
    redirect_to @image.full_filename(w,h)
  end

  def article_image
    redirect_to "#{par("article_image_root")}/#{params[:filename]*"/"}"
  end
    
  def article_thumb
    m=(/(\d+)x(\d+)/.match(params[:dims]))
    w,h=m[1].to_i,m[2].to_i
    InexUtils::article_thumbnail!("#{params[:filename]*"/"}",w,h)
    redirect_to InexUtils::article_thumbnail_filename("#{params[:filename]*"/"}",w,h)
  end
  
end
