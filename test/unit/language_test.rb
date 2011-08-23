require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase

  def test_get_by_code
    assert_equal languages(:czech), Language.find_by_code('cs')
    assert_equal languages(:english), Language.find_by_code('en')
  end
  
  def test_default
    assert_equal languages(:czech), Language.default
  end

end
