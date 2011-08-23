module Workcamps::ApplyFormHelper

  # TODO - implement form without this stupid method
  def tfield( name, options = {})
    options = adjust( name, options)
    @f.text_field name, options.merge(:size => 25)
  end

  # TODO - implement form without this stupid method
  def tarea( name, options = {})
    options = adjust( name, options)
    @f.text_area name, options.merge(:cols => 200)
  end

  # TODO - implement form without this stupid method
  def group(legend, &block)
      concat(content_tag('fieldset', content_tag('h4', bt(legend)) + capture(&block), {:class => "application_form"}), block.binding)
  end

  private

  def adjust( name, options)
    options.update :label => bt(name.to_s) unless options.key? :label
    # FIXME - use label CSS styling
    options.update :label => "#{options[:label]}*" if ApplyForm.require?(name)
    options
  end

end
