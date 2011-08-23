require 'test/test_helper'

class AdminMenuClickTest < ActionController::IntegrationTest

  def setup
    MockResources::mock_all
  end

  def test_click_items
    links = []

    ['cs','en'].each do |lang|
      post_via_redirect "/session", { :login => "admin", :password => "test" }
      get_via_redirect admin_path( :language_code => lang)
      menu_tag = nil

      assert_select 'ul#menu' do |tag|
        menu_tag = tag.first
      end

      found_links = extract_all_children(menu_tag, "a")

      for link in found_links
        href = link.attributes["href"]
        text = link.children.last.content
        # add link unless it's a javascript action (i.e. advanced menu roll/unroll button)
        links << [href, text] unless href == '#'
      end
    end

    for link, menuitem in links.uniq do
      get_via_redirect link
      assert_response :success, "Failed to open '#{menuitem}'[#{link}]"
    end
  end

end
