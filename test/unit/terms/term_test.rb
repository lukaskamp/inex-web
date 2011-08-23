require 'test/test_helper'


class TermTest < ActiveSupport::TestCase
  
  def test_validation
    assert_equal false, StaticTerm.new( :to => '' ).valid?
    assert_equal false, StaticTerm.new( :to => '', :from => '' ).valid?
    assert_equal false, StaticTerm.new( :to => nil, :from => nil ).valid?
    assert_equal false, StaticTerm.new( :to => 1.day.ago, :from => Date.today ).valid?

    assert StaticTerm.new( :to => Date.today, :from => Date.today ).valid?
    assert StaticTerm.new( :to => Date.today, :from => 1.day.ago.to_date ).valid?
  end
  
  def test_dynamic_validation
    assert RecentYear.new.valid?
  end
  
end