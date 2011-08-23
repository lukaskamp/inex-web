module ParameterAware
  
  def par(key)
    Parameter::get_value(key)
  end
  
end