class GalleryController < PublicController
    
  def index
    root_album = MediaAlbum.root(@current_language)
    raise "Root album not found" unless root_album 
    redirect_to album_path(:id => root_album.id, :language_code => @current_language.code)
  end
  
  def show
    begin
      @album = MediaAlbum.find(params[:id])
    rescue 
      redirect_to(:action => :index, :language_code => @current_language.code) and return
    end
    
    @chain = @album.parent_chain + [@album]
    @sub_albums = @album.media_albums
    @sub_files = @album.files_for_user
    if @album.parent
      @title = @album.title
      @parent = @album.parent
    end
  end
  
  def browse
    load_browser
  end

  def update_browser
    load_browser
    render :partial => @sub_files[@index].browser_name if @album
  end

  private
  
  def load_browser
    @album = MediaAlbum.find(params[:id]) rescue nil    
    redirect_to(:action => :index, :language_code => @current_language.code) and return unless @album
    
    @chain = @album.parent_chain + [@album]

    @sub_files = @album.files_for_user
    @index = (params[:index] || 0).to_i
    @index_max = @sub_files.size - 1 
  end
  
end
