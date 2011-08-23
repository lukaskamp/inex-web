require 'test/test_helper'
require 'test/mock_resources'

class ApplyFormRemoteTest < ActiveSupport::TestCase

  def setup
    MockResources::mock_all
  end

  def test_creation_from_local
    ApplyFormRemote.create_from_local(apply_forms(:valid))
  end

end

