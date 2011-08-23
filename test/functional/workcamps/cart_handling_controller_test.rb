require 'test/test_helper'
require 'test/mock_resources'


class Workcamps::CartHandlingControllerTest < ActionController::TestCase

  def setup
    super
    MockResources::mock_all
    @wc1 = Workcamp.find(:first).id
    @wc2 = Workcamp.find(:last).id
  end


  def test_adding_workcamp_to_cart
      [ @wc1, @wc2 ].each_with_index do |id,index|
          xhr :post, :add_workcamp_to_cart, :id => id, :language_code => 'en', :active_menu_item => 0
          assert_response :success
          assert_workcamps_in_cart (index+1), :xhr => true
      end
  end

  def test_empty_cart
      xhr :post, :add_workcamp_to_cart, :id => @wc1, :language_code => 'en', :active_menu_item => 0
      xhr :post, :add_workcamp_to_cart, :id => @wc2, :language_code => 'en', :active_menu_item => 0
      assert_workcamps_in_cart 2, :xhr => true

      xhr :post, :empty_cart, :language_code => 'en', :active_menu_item => 0
      assert_workcamps_in_cart 0, :xhr => true
  end

  def test_add_remove_country
    # TODO - test 'BO' - there is no workcamp
    [ 'AT', 'US' ].each do |country|
        xhr :post, :add_country, :code => country, :language_code => 'en', :active_menu_item => 0
        assert_response :success
        @cart = @request.session[:cart]
        assert @cart.country_codes.include?(country)

        xhr :post, :remove_country, :code => country, :language_code => 'en', :active_menu_item => 0
        assert_equal false, @cart.country_codes.include?(country)
        assert_response :success
    end
  end

  def test_routing
    opts = { :language_code => "cs", :controller => "workcamps/cart_handling", :action => 'add_country' }
    assert_recognizes opts, "/cs/fn/workcamps/cart_handling/add_country"
  end

  protected

  def assert_workcamps_in_cart(wc_count, options = { :xhr => false })
    if options[:xhr]
      assert_select_rjs :replace, 'cart' do
        check_cart_items wc_count
       end
    else
      assert_select 'div[id=cart]' do
        check_cart_items wc_count
      end
    end
  end

  def check_cart_items(wc_count)
    assert_select('table[id=cart_workcamps] > tbody > tr', {:count => wc_count })
  end


end
