class MediaAlbum < ActiveRecord::Base
  
  belongs_to :parent, :class_name => "MediaAlbum", :foreign_key => :media_album_id
  has_many :media_albums, :order => "position, title, filename"
  has_many :media_files, :order => "position, title, filename"
  belongs_to :true_cover, :class_name => "MediaFile", :foreign_key => :cover_id
  belongs_to :language
  
  include InexHelpers
  
  acts_as_indexed :fields => [:title, :description]
                   
  def cover
    true_cover.image_file
  end
  
  def count
    media_albums.size + media_files.size
  end
  
  def parent_chain
    if parent
      parent.parent_chain + [parent]
    else
      []
    end
  end
  
  def fulltext_formatter_name
    "format_media_album_for_fulltext"
  end
    
  def to_label
    if title and not title.empty?
      title
    else
      filename
    end
  end

  # see the same method in MediaSynchronizer module
  def fix_positions(recursive = true)
    media_albums.each {|a| a.fix_positions} if recursive
    [media_albums, media_files].each do |array|
      array.each_with_index do |item, i|
        item.position=(i+1)*10
        item.save(false)
      end
    end
  end
    
  # if w and h are give, return thumbnail path, otherwise just the directory path
  def full_path(w=nil, h=nil)
    path = if parent
      parent.full_path + "/" + filename
    else
      par("media_gallery_root")
    end 

    path += "/.#{w}x#{h}" if w and h  
    return path  
  end
  
  # if w and h are give, return thumbnail path, otherwise just the directory path
  def absolute_path(w=nil, h=nil)
    InexUtils::public_root + full_path(w, h)
  end
  
  def self.root(language)
    MediaAlbum.find(:first, :conditions => [ "media_album_id IS NULL AND language_id = ?",language.id ] )
  end

  def self.create_root(language)
    MediaAlbum.new(:filename => "", :language_id => language.id).save! unless root(language)
  end

  def thumb_filename(w, h)
    return full_path + "/.cover_#{w}x#{h}.jpg"
  end
  
  def thumbnail(w, h)
    thumbnail!(w, h) unless File::exists?(InexUtils::public_root + thumb_filename(w,h))
  end
  
  def clear_thumbnails
    Dir[InexUtils::public_root + full_path + "/.cover*.jpg"].each do |x| 
      File::delete(x)
    end
  end
  
  def self.clear_thumbnails
    MediaAlbum.find(:all).each{|a| a.clear_thumbnails}
  end
  
  def thumbnail!(w, h)
    if cover
      img = Thumber::make_thumbnail(InexUtils::public_root+cover.full_filename, w, h)
      
      # icon = Magick::Image.read(RAILS_ROOT + par("folder_icon_filename")).first
      # 
      # img.composite!(icon, Magick::CenterGravity, w*0.3, h*0.3,  Magick::ReplaceCompositeOp)
    else
      img = Thumber::make_thumbnail(RAILS_ROOT + par("folder_image_filename"), w, h)
    end
    img.write(InexUtils::public_root + thumb_filename(w, h))
  end
  
  def files_for_user
    media_files.select{|f| f.visible_for_user?}
  end

  def files_for_admin
    media_files.select{|f| f.visible_for_admin?}
  end

  def sub_dir_names
    Dir[absolute_path + "/*"].select{|fn| fn =~ /^[\/a-zA-Z0-9_\-\. ]+$/}.select{|x| File::directory?(x)}.map{|x| File::basename(x)}.sort
  end
  
  def sub_file_names
    Dir[absolute_path + "/*"].select{|fn| fn =~ /^[\/a-zA-Z0-9_\-\. ]+$/}.reject{|x| File::directory?(x)}.map{|x| File::basename(x)}.sort
  end
  
end
