require 'test/test_helper'

class SurveyControllerTest < ActionController::TestCase
  
  VALID = {
    :firstname => 'John',
    :lastname => 'Silver',
    :projectcountry => 'Denmark',
    :project => 'Legoland Actor',
    :email => 'a@b.com',
    :age => 3,
    :findinex => 4,
    :findproject => 5,
    :newsletter => 'someone@email.cz',
    :created_at => (1 + rand(6)).month.ago,
    :updated_at => rand(6).day.ago    
  }
  
  INVALID = Hash.new(VALID).replace( :email => '' )  
  
  def setup
    Survey::EVALUATION_ATTRIBUTES.each { |field| VALID.update field => '3' }
    Survey::YES_NO_ATTRIBUTES.each { |field| VALID.update field => 'Ano' }    
  end
  
  def test_index
    for_all_users_and_langs do |lang|
      get :index, :language_code => lang, :active_menu_item => 0
      assert_response :success
      assert_template 'index'
    end
  end
  
  def test_send      
    for_all_users_and_langs do |lang|
      @request.env['HTTP_REFERER'] = "/#{lang}/public/index"
      
      # submit valid form           
      post :index, :survey => VALID, :language_code => lang, :active_menu_item => 0
      assert_valid assigns['survey']
      assert_redirected_to :action => :successful
      
      # submit invalid form           
      post :index, :survey => INVALID, :language_code => lang, :active_menu_item => 0
      assert_invalid assigns['survey']
      assert_response :success
    end      
  end

  def test_validation
    for_all_users_and_langs do |lang|
      # invalid form
      post :index, :survey => VALID.update({ :rating => -1 }), :language_code => lang, :active_menu_item => 0
      assert_response :success
      assert !assigns(:show_intro)
      assert_template 'index'
      assert_invalid assigns(:survey), [ :rating ]
    end
  end
  
end
