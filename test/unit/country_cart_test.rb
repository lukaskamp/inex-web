require 'test/test_helper'
require 'test/mock_resources'

class CountryCartTest < ActiveSupport::TestCase

  def setup
    @cart = CountryCart.new
    MockResources::mock_all
  end

  def test_country_handling
    austria = Country.find_by_code('AT')
    @cart.add_country(austria)
    assert_equal austria, @cart.countries.first
    @cart.remove_country('AT')
    assert @cart.country_codes.empty?
  end

end
