class MenuItemMediaAlbum < MenuItem
  
  belongs_to :media_album, :foreign_key=>:target_id
  
  def target
    target_id
  end

  def target=(x)
    self.target_id = x
  end
  
  def target_label
    media_album.to_label if media_album
  end

  def self.menu_type_description
    "This menu item points directly to one particular media album."
  end

  def target_url
    {:route => :album, :id => target_id}
    #"/#{language.code}/gallery/show/#{target_id}"
  end

# TODO:  def edit_target_url

  def self.targets_for_as(language)
    set = [["--none--",nil]]
    # the /is not null/ has to be there to exclude the root albums
    MediaAlbum.find(:all,:conditions=>["language_id = ? AND media_album_id IS NOT NULL", language.id],:order=>:title).each do |album|
      set.push([album.to_label,album.id])
    end
    set
  end  
  
end