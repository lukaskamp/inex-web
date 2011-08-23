class Admin::BannersController < Admin::AdminController

  active_scaffold :banners do |c|
    c.columns = [ :image_filename, :order, :name, :url ]
    c.columns[:image_filename].form_ui = :select
    
    c.columns[:url].description = '<br/>Full address of the link (for example "http://www.seznam.cz")'
    c.columns[:name].description = '<br/>Name of the referred page'
    c.columns[:order].description = '<br/>The lower the number, the higher is the banner on the page. Banners with the same number are grouped and cycle.'
  end

  # must be included after the 'active_scaffold' call to work
  include LanguageAware

  prepare_image_filename_select

  def do_new
    super
    @image_filename_select_options ||= @@image_filename_select_options
  end

  def do_edit
    super
    @image_filename_select_options ||= @@image_filename_select_options
  end

end
