class NewLayoutParameters < ActiveRecord::Migration
  def self.up
    Parameter.delete(Parameter.find_by_key('button_text_x').id)
    Parameter.delete(Parameter.find_by_key('button_text_y').id)
    Parameter.delete(Parameter.find_by_key('button_template_on').id)
    Parameter.delete(Parameter.find_by_key('button_template_off').id)

    p StringParameter.create(:key => 'button_background_on', :value => '#74a8bf',  :description => 'Top-menu button background (active state).')
    p StringParameter.create(:key => 'button_background_off', :value => '#ffffff',  :description => 'Top-menu button background (normal state).')
  end

  def self.down
    p IntegerParameter.create(:key => 'button_text_x', :value => 0,  :description => '')
    p IntegerParameter.create(:key => 'button_text_y', :value => 0,  :description => '')
    p StringParameter.create(:key => 'button_template_on' , :value => '',  :description => '')
    p StringParameter.create(:key => 'button_template_off', :value => '',  :description => '')

    Parameter.delete(Parameter.find_by_key('button_background_on').id)
    Parameter.delete(Parameter.find_by_key('button_background_off').id)
  end
end
