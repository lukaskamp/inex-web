class MenuItem < ActiveRecord::Base  
  
  include ActAsAuthored
  
  acts_as_tree :order => 'position ASC'
  belongs_to :language  
  
  validates_presence_of :title, :position, :language
  validates_numericality_of :position             
  validates_url_atom
  
  acts_as_indexed :fields => [:title]         

  include InexHelpers
  include FulltextHelper
    
  def self.root_menu_items(language)
    MenuItem.find(:all, 
                  :conditions => [ 'parent_id IS NULL AND language_id = ?', language.id], 
                  :order => 'position ASC' )
  end
  
  def top?
    !parent_id
  end
  
  def url_atoms
    parent ? (parent.url_atoms + "/" + url_atom) : url_atom
  end
  
  def self.create_all_icons
    Language.find(:all).each do |lang|
      MenuItem.find(:all, :conditions => {:language_id => lang.id, :parent_id => nil}, :order => :position).each_with_index {|mi, i| mi.create_menu_icons(1+i)}
    end
  end
  
  def menu_icon_filename(which,position)
    "/images/menu_icon_#{self.language.code}_#{position}_#{which}.png"
  end
  
  def menu_icons_exist?
    File::exists?(menu_icon_filename(:on)) and File::exists?(menu_icon_filename(:off))
  end
  
  def create_menu_icons(position)
    [:on, :off].each do |sym|
      makebutton("/public" + menu_icon_filename(sym,position), title, par("button_color_#{sym}"), par("button_background_#{sym}"))
    end
  end
  
  def to_label
    help.truncate(title, 30)
  end
  
  def target_parameters
    nil
  end

  def target
    nil
  end
  
  def self.required_fields
    []
  end
  
  def target_label
    ""
  end
  
  def self.menu_type_description
    "This menu item will be rendered normally, but won't be doing anything when clicked at."
  end
  
  def self.targets_for_as(language)
    nil
  end

  def fulltext_formatter_name
    "format_menu_item_for_fulltext"
  end
    
  def target_url
    {}
  end
  
  def edit_target_url
    nil
  end

protected

  def makebutton(dst, text, color, background)
    return if InexUtils::test_env?
  	require 'RMagick'
  	icon = Magick::Image.new(180,26) {self.background_color = background}

  	drawable = Magick::Draw.new
  	drawable.pointsize = par("button_font_size")
  	drawable.font = ("#{RAILS_ROOT}#{par("button_font")}")
  	drawable.fill = color
  	drawable.gravity = Magick::CenterGravity

  	drawable.annotate(icon, 0, 0, 0, 0, text)

  	icon.write("#{RAILS_ROOT}#{dst}")
  end
  
end
