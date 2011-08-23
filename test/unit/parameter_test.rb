require 'test/test_helper'

class ParameterTest < ActiveSupport::TestCase

  def test_parameter_values
    assert_equal nil, Parameter::get_value("parameter_nil")
    assert_equal 5, Parameter::get_value("parameter_int")
    assert_equal "text", Parameter::get_value("parameter_str")
    assert_equal 2.5, Parameter::get_value("parameter_float")
  end

end
