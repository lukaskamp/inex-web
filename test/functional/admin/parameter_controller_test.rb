require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'

class Admin::ParameterControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldCRUDTester

  def test_edit_by_key
    get :edit_by_key, :language_code => 'cs', :code => WorkcampSearch::SEASON_START_PARAM
    assert_redirected_to :action => :edit
  end

  protected

  def item
    # TODO - add other parameters
    parameters(:headline_annotation_length)
  end

end
