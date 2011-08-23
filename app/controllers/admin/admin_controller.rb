class Admin::AdminController < ApplicationController
  
  before_filter :login_required
  layout "admin"
  skip_before_filter :load_menu_chain
  
  def index
    redirect_to :controller => 'article', :action => 'list'
  end
  
  ActiveScaffold.set_defaults do |config| 
    config.show.link.label = 'Details'    
  end

  def menu_actions
  end

  def switch_advanced_menu
    @current_user.toggle!(:show_advanced_menu)
    render :template => 'admin/admin/switch_advanced_menu.rjs'
  end
  
  protected

  def self.prepare_image_filename_select
    @@image_filename_select_options = [["--none--", nil]]
 
    InexUtils::article_image_list.each do |filename|
      @@image_filename_select_options.push([filename,filename])
    end
  end

  def self.exclude_user_cols_from_edit(config)
    config.update.columns.exclude :created_by, :updated_by
    config.create.columns.exclude :created_by, :updated_by
  end
  
  # Adds table level (unless overriden by options) link 
  # to ActiveScaffold local configuration using either 
  # 'action' or :action and :controller options entries
  # to create HREF. The parameter definition is updated 
  # for any specific changes from the options hash.
  def self.action_link(config, action, label, icon, options = nil)
      params = {:crud_type => nil, 
                :label => help.icon( icon, label),
                :type => :table,
                :inline => false }
                
      params.update(options) if options    
      config.action_links.add( action, params)
  end
   
   
end
