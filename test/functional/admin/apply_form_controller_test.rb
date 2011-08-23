require 'test/test_helper'
require 'test/functional/admin/active_scaffold_read_only_tester'

class Admin::ApplyFormControllerTest < ActionController::TestCase

 include Admin::ActiveScaffoldReadOnlyTester

 def setup
   super
   MockResources::mock_all
 end

 def test_workcamp_connection_check
   get :connection_info, :language_code => 'cs'
   assert_response :success
 end

 def test_workcamp_connection_check
   xhr :get, :workcamp_connection_check, :language_code => 'cs'
   assert_response :success
   assert_select_rjs "connection_message"
 end

 protected

 def item
   ApplyForm.find(:first)
 end

end
