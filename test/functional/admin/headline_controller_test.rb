require 'test/test_helper'
require 'test/functional/admin/active_scaffold_crud_tester'

class Admin::HeadlineControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldCRUDTester
    
  def test_real_request
      id = Headline.find(:first).id
      params = {"commit"=> "Update", 
                 "id"=> id, 
                 "controller"=>"admin/headline", 
                 "language_code"=>"cs", 
                 "record"=> { "article"=>{"id"=>""}, 
                              "valid_to"=>"29.11.2008", 
                               "title"=>"Novinka", 
                               "annotation_explicit"=>"", 
                               "valid_from"=>"19.11.2008"}}
                               
      post :update, params      
      assert_valid assigns(:record)
  end
    
  protected 
  
  def item
    headlines(:en_expired)
  end

end
