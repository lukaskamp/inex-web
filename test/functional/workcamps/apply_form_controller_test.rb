require 'test/test_helper'

class Workcamps::ApplyFormControllerTest < ActionController::TestCase

  def setup
    @empty_address = { :street => '', :city => '', :zipcode => '' }
    address = { :street => 'eee', :city => 'eee', :zipcode => 'eee' }

    @form = {
      :firstname => 'eee',
      :lastname => 'eee',
      :birthnumber => '800322097',
      :birthdate => '1.12.1980',
      :gender => 'm',
      :contact_address => address,

      :emergency_name => 'Someone',
      :emergency_day => '+420876987',
      :emergency_night => '+420876987',

      :email => 'eee',
      :phone => '+420909223',
      :nationality => 'eee',
      :occupation => 'eee',
      :address => address,
      :motivation => "I don't wanna go there...",

      :terms_of_processing => 1,
      :terms_of_workcamps => 1
    }
  end


  # no workcamp in the cart -> redicted to search
  def test_show_form_failed
    get :apply, :language_code => 'cs', :active_menu_item => 0
    assert_invalid assigns(:apply_form)
    assert_template 'workcamps/apply_form/apply'
  end

  def test_no_address
    wrong_form = @form.update :address => @empty_address
    get :apply, :language_code => 'cs', :apply_form => wrong_form, :active_menu_item => 0
    assert_invalid assigns(:apply_form), [ :address ]
  end

  def test_show_form
    fill_cart
    get :apply, :language_code => 'cs', :active_menu_item => 0
    assert_response :success
    assert_template 'workcamps/apply_form/apply'
  end

  def test_application_submit
    fill_cart
    post :apply, :language_code => 'cs', :apply_form => @form, :active_menu_item => 0
    assert_valid assigns(:apply_form)
    assert_redirected_to :action => :success
  end

  private

  def fill_cart
    @cart = Cart.new
    @cart.add_workcamp(Workcamp.find(:first))
    @request.session[:cart] = @cart
  end
end
