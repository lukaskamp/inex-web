class AddParametersForLayout < ActiveRecord::Migration
  def self.up
    p StringParameter.create(:key => 'layout_image_root', :value => '/data/layout', :description => 'Root directory for layout, user-modifiable data.')
    p StringParameter.create(:key => 'top_banner_filename', :value => 'top_image_01.png', :description => 'Filename of banner on the home page.')
    p StringParameter.create(:key => 'top_banner_position', :value => 'left top', :description => 'Banner position on the home page.')
    p StringParameter.create(:key => 'button_template_on', :value => '/images/layout/button_on.png', :description => 'Template of an active top-menu button.')
    p StringParameter.create(:key => 'button_template_off', :value => '/images/layout/button_off.png', :description => 'Template of an inactive top-menu button.')
    p StringParameter.create(:key => 'button_color_on', :value => '#ffffff', :description => 'Text color of an active top-menu button.')
    p StringParameter.create(:key => 'button_color_off', :value => '#000000', :description => 'Text color of an inactive top-menu button.')
    p StringParameter.create(:key => 'button_font', :value => '/lib/ElektraMedium.otf', :description => 'Font filename of the top-menu buttons.')
    p FloatParameter.create(:key => 'button_font_size', :value => 14.0, :description => 'Font size of the top-menu buttons.')
    p IntegerParameter.create(:key => 'button_text_x', :value => 95, :description => 'X-position of text in the top-menu buttons.')
    p IntegerParameter.create(:key => 'button_text_y', :value => 4, :description => 'Y-position of text in the top-menu buttons.')
    add_column :menu_items, :banner_filename, :string
    add_column :menu_items, :banner_position, :string
  end

  def self.down
    Parameter.delete(Parameter.find_by_key('layout_image_root').id)
    Parameter.delete(Parameter.find_by_key('top_banner_filename').id)
    Parameter.delete(Parameter.find_by_key('top_banner_position').id)
    Parameter.delete(Parameter.find_by_key('button_template_on').id)
    Parameter.delete(Parameter.find_by_key('button_template_off').id)
    Parameter.delete(Parameter.find_by_key('button_color_on').id)
    Parameter.delete(Parameter.find_by_key('button_color_off').id)
    Parameter.delete(Parameter.find_by_key('button_font').id)
    Parameter.delete(Parameter.find_by_key('button_font_size').id)
    Parameter.delete(Parameter.find_by_key('button_text_x').id)
    Parameter.delete(Parameter.find_by_key('button_text_y').id)
    remove_column :menu_items, :banner_filename
    remove_column :menu_items, :banner_position
  end
end
