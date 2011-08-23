require "#{RAILS_ROOT}/lib/inex_utils"
require "#{RAILS_ROOT}/lib/thumber"
require 'ftools'

class MediaFile < ActiveRecord::Base

  include InexHelpers
  
  belongs_to :media_album
  
  acts_as_indexed :fields => [:title, :description]
  
  def fulltext_formatter_name
    "format_media_file_for_fulltext"
  end

  def clear_thumbnails
    MediaFile.delete(self.id) and return unless media_album
    (Dir.entries(media_album.absolute_path)-[".",".."]).select{|x| x=~/\.(\d+)x(\d)/}.each do |dir_name|
      Dir[media_album.absolute_path+"/"+dir_name+"/*"].each do |file_name|
        File::delete(file_name)
      end
    end
  end  
  
  def image_file
    self
  end

  def visible_for_admin?
    displayable? and not virtual?
  end
  
  def visible_for_user?
    displayable? and not virtual? and not hidden?
  end
  
  def virtual?
    virtual and virtual>0
  end
  
  def hidden?
    hidden and hidden>0
  end
  
  def self.clear_thumbnails
    MediaFile.find(:all).each{|f| f.clear_thumbnails}
  end
  
  def full_filename(w=nil,h=nil)
    media_album.full_path(w,h) + "/" + filename
  end
  
  def absolute_filename(w=nil, h=nil)
    InexUtils::public_root + full_filename(w,h)
  end

  def displayable?
    false
  end
  
  def get_index_in_album
    media_album.displayable_files.index(self)
  end  

end
