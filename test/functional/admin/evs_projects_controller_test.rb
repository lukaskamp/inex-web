require 'test/test_helper'

class Admin::EvsProjectsControllerTest < ActionController::TestCase
  
  def setup
    login_as 'admin'
  end

  def test_multiple_entry_and_retrieval
    post :enter_multiple, :language_code => "cs", :query => "ahoj, nevim, .. , .;; .! kopyto \\ 2007-BEFR-3 176 +,. nevim 2008-DE-11"
    assert_equal 2, EvsProject.find(:all).size
    assert_equal "2 projects added.", flash[:notice]
    EvsProject.find(:all).each do |evs|
      get :retrieve_project, :id => evs.id, :language_code => "cs", :format => "js"
      assert_response :success
      if evs.eiref == "2007-BEFR-3"
        assert assigns(:message)=~/table_add/, assigns(:message)+" not expected"
      else
        assert assigns(:message)=~/table_error/, assigns(:message)+" not expected"
      end
    end
  end

end

class EvsProject < ActiveRecord::Base

private

  def query_website(query_eiref)
    filename = "#{RAILS_ROOT}/test/fixtures/evs/#{query_eiref}"
    if File::exists?(filename)
      {:flag => :ok, :body => IO::read(filename)}
    else
      {:flag => :bad_response}
    end
  end

end

