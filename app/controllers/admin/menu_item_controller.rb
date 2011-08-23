require "#{RAILS_ROOT}/lib/inex_helpers"

class Admin::MenuItemController < Admin::AdminController

  include InexHelpers

  before_filter :load_parent, :update_table_config


  active_scaffold :menu_items do |config|
    # TODO - add :children - but just view
    config.columns = [ :url_atom, :title, :type, :help, :target,
      :target_controller, :target_action, :target_link, :position, :target_label, :top_level_banner ]

    config.show.columns = [ :url_atom, :title, :type,
        :target_controller, :target_action, :target_link, :position, :target_label ]

    config.list.columns = [ :url_atom, :title, :type, :target_label, :position  ]

    list.sorting = {:position => 'ASC'}

    config.columns[:url_atom].description = "URL part: consists only of english letters, hyphens and numbers"

    config.columns[:target_label].label = "Target of item"
    config.columns.exclude :target_label
    config.columns.exclude :banner_filename
    config.columns.exclude :banner_position

    config.action_links.add 'edit_submenu',
                            :crud_type=>nil,
                            :label => 'Edit submenu',
                            # TODO - make it inline?
                            :inline=> false,
                            :type=>:record,
                            :dhtml_confirm=>false,
                            :confirm=>false,
                            :position=>false

    config.action_links.add 'make_icons',
                            :crud_type=>nil,
                            :label => 'Re-create icons',
                            :inline=> false,
                            :type=>:table,
                            :dhtml_confirm=>false,
                            :confirm=>false,
                            :position=>false
  end

   # must be included after the 'active_scaffold' call to work
  include LanguageAware

  def conditions_for_collection
    params = [ @current_language.id ]
    condition = '(menu_items.language_id = ?) AND '

    if @parent.nil?
      condition += '(menu_items.parent_id is NULL)'
    else
      condition += '(menu_items.parent_id = ?)'
      params.push @parent.id
    end

    condition = "menu_items.language_id = #{@current_language.id} AND "

    if @parent.nil?
      condition << "menu_items.parent_id is NULL"
    else
      condition << "menu_items.parent_id = #{@parent.id}"
    end
    condition
  end

  def make_icons
    MenuItem::create_all_icons
    redirect_to :action => :list
  end

  # these two callbacks solve the unpleasant inheritance problem.
  # the do_create is certainly kinda dirty, but there are not many possibilities...

  def do_update
    # set the class
    record = MenuItem.find(params[:id])
    record.type = params[:record][:type]
    record.save
    super
    @record.banner_filename = params[:record][:banner_filename]
    @record.banner_position = params[:record][:banner_position]
    result = @record.save
    @record = MenuItem.find(@record) if result
    !!result
  end

  def do_create
    if params[:record][:target]
      # set the target in a painful way
      target = params[:record][:target].dup
      params[:record].delete(:target)
      super
      new_record = Kernel.const_get(@record.type).new
      new_record.attributes = @record.attributes
      new_record.target = target
      @record = new_record
    else
      super
    end
    @record.banner_filename = params[:record][:banner_filename]
    @record.banner_position = params[:record][:banner_position]
    result = @record.save
    @record = MenuItem.find(@record) if result
    @record
  end

  def edit_submenu
    redirect_to :action => "index", :parent_id => params[:id]
  end

  def reload_help
    update_record_type
    @help_text = @record_class.menu_type_description
    render :partial => "help_form_column"
  end

  def reload_target_link
    update_record_type
    @link_required = (@record_class.required_fields.include? :link)
    render :partial => "target_link_form_column"
  end

  def reload_target_action
    update_record_type
    @action_required = (@record_class.required_fields.include? :action)
    render :partial => "target_action_form_column"
  end

  def reload_target_controller
    update_record_type
    @controller_required = (@record_class.required_fields.include? :controller)
    render :partial => "target_controller_form_column"
  end

  def reload_target
    update_record_type
    @target_options = @record_class.targets_for_as(@current_language)
    render :partial => "target_form_column"
  end

  # overriden method from LanguageAware because we have to set 'parent' as well
  def before_create_save(record)
    record.language = @current_language
    record.parent_id = params[:parent_id]
  end

private

  def update_table_config
    unless @parent.nil?
       active_scaffold_config.label = "<div style=\"margin-right:270px;\" >Submenu '#{help.render_breadcrumb(@current_language,@parent)}'</div>"
    else
       active_scaffold_config.label = "Main menu"
    end
  end

  def load_parent
    @parent = MenuItem.find(params[:parent_id]) unless params[:parent_id].nil?
  end

  def update_record_type
    @record_class = eval(params[:type])
    if params[:record] and params[:record].to_i > 0
      @record = MenuItem.find(params[:record].to_i)
    else
      @record = @record_class.new
    end
  end

end
