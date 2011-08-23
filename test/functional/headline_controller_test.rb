require 'test/test_helper'

class HeadlineControllerTest < ActionController::TestCase

  # Test headlines in all languages with all users
  def test_headlines
    # test HTML headlines
    for_all_users do
      get(:index, {:language_code => 'en'})
      assert_response :success
      assert_contains_headlines
      
      get(:index, {:language_code => 'cs'})
      assert_response :success
      assert_select "td#content > div.inner", true, "Content block not present" do
        assert_select "div.headline_list_item", true, "Found no cs headlines"
      end
    end
    
    # test RSS headlines
    for_all_users do 
      get(:atom, {:language_code => 'en'})
      assert_response :success
      assert_select 'feed > title'
      assert_select('feed > entry', {:count => 3})

      get(:atom, {:language_code => 'cs'})
      assert_response :success
      assert_select 'feed > title'
      assert_select('feed > entry')
    end    
  end
    
  def test_routing  
    opts = { :language_code => "cs", :controller => "headline", :action => "index", :path => "" }
    assert_recognizes opts, "/cs"
    
    opts = { :language_code => "cs", :controller => "headline", :action => "atom", :format => :atom }
    assert_recognizes opts, "/cs/atom"

    opts = { :language_code => "cs", :controller => "headline", :action => "feed", :format => :xml }
    assert_recognizes opts, "/cs/rss"
  end
    
  private
    
  def assert_contains_headlines
    assert_select "td#content > div.inner" do
      assert_select "div.headline_list_item", :count => 3
      titles = (1..3).map do |i|
        t = nil
        assert_select "div.headline_list_item:nth-of-type(#{i}) div.headline_list_title" do |tag|
          t = tag.first.children.first.content.chomp.strip
        end
        t
      end
      assert_equal ['1.Unexpired Headline', '2.Unexpired Headline', 'Expired Headline'], titles.sort
    end    
  end 

end
