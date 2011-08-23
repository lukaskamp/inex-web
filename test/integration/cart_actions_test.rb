require 'test/test_helper'

class CartActionsTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_cart_handling
    # TODO - uncomment
#    radka = regular_user
#    radka.checks_cart_has :wc_count => 0
#    radka.goes_to_workcamps
#    radka.searches_and_looks_at_links
#    radka.adds_workcamp
#    radka.checks_cart_has :wc_count => 1
#    radka.empties_cart
#    radka.checks_cart_has :wc_count => 0
  end

  def regular_user
    open_session do |user|
      def user.goes_to_workcamps
        get "/cs/fn/workcamps/search/search"
        assert_template 'workcamps/search/search'
      end

      def user.goes_to_headlines
        get_via_redirect "/cs/public"
        assert_template 'headline/list'
      end

      def user.searches_and_looks_at_links
        get "/cs/fn/workcamps/search/list", :query => { :from => nil }
        assert_template 'workcamps/search/list'
        assert_response :success
        assert_select "table#workcamps tbody tr"
      end

      def user.adds_workcamp
        xhr :post, "/cs/fn/workcamps/cart_handling/add_workcamp_to_cart", :id => 1, :language_code => 'en'
        assert_response :success
      end

      def user.empties_cart
        xhr :post, "/cs/fn/workcamps/cart_handling/empty_cart", :language_code => 'en'
        assert_response :success
      end

      def user.checks_cart_has(options = {})
         # there has to be some normal request before check because xhr doesn't update the page while testing
#         goes_to_workcamps
#        wc_count = options[:wc_count] || 0
#         assert_select 'div#cart table#cart_workcamps tbody tr', :count => wc_count
      end

    end
  end

end
