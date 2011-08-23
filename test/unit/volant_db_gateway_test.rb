require 'test/test_helper'

class WorkcampDbGateway < ActiveSupport::TestCase

  VALID_QUERY = { :age => nil, :from => nil, :to => nil, :country => nil, :aim => nil }

  def test_connection_checker
    assert VolantDbGateway.test_connection
  end

  def test_search
    WorkcampSearch.find_by_query(VALID_QUERY)
  end

end
