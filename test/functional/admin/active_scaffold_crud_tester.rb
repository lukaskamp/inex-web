require 'test/test_helper'
require 'test/functional/admin/active_scaffold_read_only_tester'

module Admin::ActiveScaffoldCRUDTester
  
  include Admin::ActiveScaffoldReadOnlyTester

  def test_edit
    assert_item_defined
    get :edit, :id => item.id, :language_code => 'cs'
    assert_response :success
    assert_template 'update_form'
  end

  def test_show
    assert_item_defined
    get :show, :id => item.id, :language_code => 'cs'
    assert_response :success
    assert_template 'show'
  end

  def assert_item_defined
    fail "define 'item' method for the test class for Admin::ActiveScaffoldCRUDTester" unless self.respond_to? :item
  end
  
end