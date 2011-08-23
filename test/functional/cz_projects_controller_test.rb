require 'test/test_helper'

class CzProjectsControllerTest < ActionController::TestCase

  def test_index
    get :index, :language_code => 'cs', :active_menu_item => 0
    assert_response :success
    assert_equal 4, assigns(:kinds).size
    assert_equal 4, assigns(:projects).keys.size

    assert_equal [cz_projects(:svijany)], assigns(:projects)[cz_project_kinds(:one)]
    assert_equal [], assigns(:projects)[cz_project_kinds(:bridges)]
  end

end


=begin
assert_select "div#content" do
  assert_select "p.cz_project_kind_head", :count => 2
  assert_select "p.cz_project_kind_desc", :count => 2
  assert_select "p:nth-of-type(1)", :text => "(cz_kind_title_bio)"
  assert_select "p:nth-of-type(3)", :text => "(cz_kind_title_eko)"
  assert_select "p+ul", :count => 2
  assert_select "ul:nth-of-type(1)" do
    assert_select "li", :count => 1
    assert_select "li>b", :text => "Svijany"
  end
  assert_select "ul:nth-of-type(2)" do
    assert_select "li", :count => 0
  end
end
=end