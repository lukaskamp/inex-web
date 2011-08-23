require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'
require 'test/functional/admin/authoring_fields_tester'


class Admin::SurveyControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldCRUDTester
# include Admin::AuthoringFieldsTester  

  def test_csv_export
    get :surveys, :language_code => 'cs', :format => 'csv'
  end
      
  protected 
  
  def item
    surveys(:volunteer_10)
  end

end
