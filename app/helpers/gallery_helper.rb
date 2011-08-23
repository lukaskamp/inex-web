module GalleryHelper
  
def navigator(index,album_id,index_max)
  '<br />'+
  '<div id="gallery_browser_footer">'+
  '<div id="gallery_browser_navigator">'+
  '<div id="gallery_browser_navigator_forward">' + "\n" +
  ( index < index_max ?
    link_to_remote( image_tag("/images/layout/browser_next_off.png", :mouseover => "/images/layout/browser_next_on.png"), 
                    { :update=>"gallery_browser", 
                      :url => {:action => "update_browser", :index => index+1, :id => album_id} }, 
                      {:id => "gallery_browser_button_next"} ) + "\n" \
  : '&nbsp;' ) +
  '</div>' +
  '<div id="gallery_browser_navigator_backward">' + "\n" +
  (index > 0 ?
    link_to_remote( image_tag("/images/layout/browser_back_off.png", :mouseover => "/images/layout/browser_back_on.png"), 
                    { :update=>"gallery_browser", 
                      :url => {:action => "update_browser", :index => index-1, :id => album_id} }, 
                    {:id => "gallery_browser_button_previous"} ) + "\n" \
  : '&nbsp;' ) +
  '</div>' +
  '</div>' +
  '<div id="gallery_browser_counter">' +
  "#{index+1} / #{index_max+1}" +
  '</div>' +
  '</div>'
end

def edit_album_link(id, text="")
  if logged_in?
    link_to icon('edit')+" #{text}", edit_album_url(:id => id, :language_code => @current_language.code)
  end
end
  
def edit_file_link(id)
  if logged_in?
    link_to icon('edit'), edit_file_url(:id => id, :language_code => @current_language.code)
  end
end
  
end
