class Admin::MediaGalleryController < Admin::AdminController
  
  include LanguageAware
  
  def index
    root = MediaAlbum.root(@current_language)
    @root_id = root.id if root    
  end
  
  def make_article_thumbnail
    InexUtils::article_thumbnail!(params[:filename], params[:xdim].to_i, params[:ydim].to_i)
#    render :partial => "make_thumbnail"
    render :text => @template.icon('add')
  end
  
  def make_thumbnail
    MediaFileImage.find(params[:id].to_i).thumbnail!(params[:xdim].to_i, params[:ydim].to_i)
#     render :partial => "make_thumbnail"
    render :text => @template.icon('add')
  end
  
  def generate_thumbnails_silently
    @dims = [
              [par("photo_x_size"), par("photo_y_size"), "Photo size"],
              [par("thumbnail_x_size"), par("thumbnail_y_size"), "Thumbnail size"]
            ]
    @files = MediaFileImage.find(:all)
    for f in @files do 
      for xdim, ydim, dim_name in @dims
        f.thumbnail!(xdim,ydim)
      end
    end
    
    @article_dims = [[par("editor_thumbnail_size"),"Thumbnail size"]]
    @article_files = InexUtils::article_image_list.sort.map{|f| {:id=>nil,:filename=>f}}
    for f in @article_files
      @article_status[f]={}
      for dim, dim_name in @article_dims
        InexUtils::article_thumbnail!(f[:filename],dim,dim)
      end
    end
    
    redirect_to :index
  end
  
  def generate_thumbnails
    @dims = [
              [par("photo_x_size"), par("photo_y_size"), "Photo size"],
              [par("thumbnail_x_size"), par("thumbnail_y_size"), "Thumbnail size"]
            ]
    @files = MediaFileImage.find(:all)
    @status = {}
    for f in @files
      @status[f]={}
      for xdim, ydim, dim_name in @dims
        @status[f]["#{xdim}x#{ydim}"] = f.thumbnail?(xdim,ydim)
      end
    end
    
    @article_dims = [[par("editor_thumbnail_size"),par("editor_thumbnail_size"),"Thumbnail size"]]
    @article_files = InexUtils::article_image_list.sort.map{|f| {:id=>nil,:filename=>f}}
    @article_status = {}
    for f in @article_files
      @article_status[f]={}
      for xdim, ydim, dim_name in @article_dims
        @article_status[f]["#{xdim}x#{ydim}"] = InexUtils::article_thumbnail?(f[:filename],xdim,ydim)
      end
    end
  end
  
  
  def edit_file
    @file = MediaFile.find(params[:id])
    if request.post?
      if @file.update_attributes(params[:media_file])
        @file.clear_thumbnails
        @file.media_album.fix_positions(false)
        redirect_to :action => :edit, :id => @file.media_album_id
      end
    end
  end
  
  def update_file_entry
    file_to_edit = MediaFile.find(params[:id])
    file_to_edit.update_attributes(params[:media_file])
    file_to_edit.clear_thumbnails
    file_to_edit.media_album.fix_positions(false)
    redirect_to :action => :edit, :id => file_to_edit.media_album_id
  end
  
  def update_album_entry
    album_to_edit = MediaAlbum.find(params[:id])
    album_to_edit.update_attributes(params[:media_album])
    album_to_edit.clear_thumbnails      
    album_to_edit.parent.fix_positions(false)
    redirect_to :action => :edit, :id => album_to_edit.media_album_id
  end
  
  def update_album_cover
    file_to_edit = MediaFile.find(params[:id])
    parent_album = file_to_edit.media_album
    parent_album.cover_id = file_to_edit.id
    parent_album.save
    parent_album.clear_thumbnails
    redirect_to :action => :edit, :id => parent_album.id
  end
  
  def edit
    @album = MediaAlbum.find(params[:id])
    @parent = @album.parent
    @sub_albums = @album.media_albums
    @sub_files = @album.files_for_admin
  end
  
  def sync
    @log = []
    @log << [:force, "asked for"] if params[:force]
    MediaSynchronizer::synchronize_gallery(@log, !!params[:force])
    if params[:force]
      MediaAlbum.clear_thumbnails
      MediaFile.clear_thumbnails
      InexUtils::clear_article_thumbnails
    end
  end
  
  def clear_thumbnails
    MediaAlbum.clear_thumbnails
    MediaFile.clear_thumbnails
    InexUtils::clear_article_thumbnails
    flash[:notice] = "Thumbnails deleted."
    redirect_to :action => :index
  end
  
end
