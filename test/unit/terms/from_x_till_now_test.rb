require 'test/test_helper'


class TermTest < ActiveSupport::TestCase

  def setup
    @term = FromXTillNow.new( :from => 1.day.ago.to_date )
  end
  
  def test_validation
    assert_equal false, FromXTillNow.new.valid?
    assert_equal false, FromXTillNow.new( :from => 1.day.from_now.to_date ).valid?
    assert @term.valid?
  end
  
  def test_label
    assert_not_nil @term.to_label
  end
    
end