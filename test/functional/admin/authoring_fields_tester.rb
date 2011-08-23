require 'test/test_helper'

module Admin::AuthoringFieldsTester

  # FIXME - the test does not fail if something is broken!
  def test_new_authored
    assert_item_defined
    get :new, :language_code => 'cs'
    assert_response :success
    assert_template 'create_form'    
    return # FIXME
    item.id = nil
    item.created_by = nil
    item.updated_by = nil
    post :new, :record => item, :language_code => 'cs'
    assert_not_nil assigns['record']
    assert_equal users(:admin), assigns['record'].created_by
    assert_equal users(:admin), assigns['record'].updated_by
  end

  # FIXME - the test does not fail if something is broken!
  def test_edit_authored    
    assert_item_defined
    get :edit, :id => item.id, :language_code => 'cs'
    assert_response :success
    assert_template 'update_form'
    return # FIXME
    item.updated_by = nil
    post :edit, :id => item.id, :record => item, :language_code => 'cs'
    assert_equal users(:admin), assigns['record'].updated_by
  end
  
  def assert_item_defined
    fail "define 'item' method for the test class for authoring test" unless self.respond_to? :item
  end
  
end