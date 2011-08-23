module Validateable

  [:save, :save!, :update_attribute].each do |attr| 
    define_method(attr) {}
  end

  # TODO - do not ignore missing methods (especially variable accessors)  
  def method_missing(symbol, *params)
    if (symbol.to_s =~ /(.*)_before_type_cast$/)
      send($1)
#    elsif instance_variables.member?(symbol)
#      super.method_missing
    end
  end
  
  module ClassMethods
    def human_attribute_name(attribute_key_name)
      attribute_key_name.humanize
    end
  end
  
  def self.included(base)
    base.send(:include, ActiveRecord::Validations)
    base.extend(ClassMethods)
  end
end