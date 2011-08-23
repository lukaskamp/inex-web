require 'test/test_helper'
require 'test/mock_resources'

class Workcamps::SearchControllerTest < ActionController::TestCase

  VALID_QUERY = { :age => nil, :from => nil, :to => nil, :country => nil, :aim => nil }

  def setup
    super
    @request.session[:cart] = nil
    MockResources.mock_all
  end

  def test_routing
    assert_recognizes({ :controller => 'workcamps/search',
                        :action => 'search',
                        :language_code => 'cs'
                        },
                      '/cs/fn/workcamps/search/search')
  end

  def test_index
    for_all_users_and_langs do |lang|
      get :index, :language_code => lang, :active_menu_item => 0
      assert_redirected_to :action => :search
    end
  end

  def test_search
    for_all_users_and_langs do |lang|
      fill_cart
      get :search, :language_code => lang, :active_menu_item => 0
      assert_equal false, assigns(:aims).empty?

      assert_template 'search'
      assert_select 'input[name=?]', /query\[(from|to)\]/
    end
  end

#   def test_show_detail
#     xhr :post, :show_detail, :id => 1, :js_id => 'dummy', :language_code => 'en', :active_menu_item => 0
#     assert_select_rjs 'dummy'
#   end

#   def test_list
#     for_all_users_and_langs do |lang|
#       fill_cart
#       get :list, :query => VALID_QUERY, :language_code => lang, :active_menu_item => 0
#       assert_template 'list'
#       assert_select 'table[id=workcamps]'
#     end
#   end

#   def test_list_with_dates
#       from = '11.11.2008'
#       to = '30.11.2008'

#       get :list,  :query => { :from => from, :to => to }, :language_code => 'cs', :active_menu_item => 0

#       # check whether 'From' dates fit
#       assert_select 'table#workcamps td.from' do |elements|
#           elements.each do |td|
#             parsed_from = td.children.first.content.strip.to_date
#             assert from.to_date <= parsed_from,
#                    "Workcamp's start #{parsed_from} is not after #{from}"
#           end
#       end

#       # check whether 'To' dates fit
#       assert_select 'table#workcamps td.to' do |elements|
#           elements.each do |td|
#             parsed_to = td.children.first.content.strip.to_date
#             assert to.to_date >= parsed_to,
#                    "Workcamp's start #{parsed_to} is not after #{to}"
#           end
#       end
#   end

  protected

  def fill_cart
    cart = Cart.new.add_workcamp( Workcamp.find(:first) )
    @request.session[:cart] = cart
  end


end
