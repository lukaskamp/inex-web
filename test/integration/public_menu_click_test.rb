require 'test/test_helper'

class PublicMenuClickTest < ActionController::IntegrationTest

  def setup
    MediaSynchronizer.synchronize_gallery(log=[], true)
  end

  def test_beastly_clicking
    links = []
    new_links = []
    ['cs', 'en'].each do |lang|
      new_links << home_path(:language_code => lang)
    end
    
    while new_links.size > 0
      link = new_links.pop
      get_via_redirect link
      links << link
      assert_response :success, "error opening #{link}"
      
      # do not process non-html responses
      if response.headers["type"].include? "text/html"
        body_tag = nil
        p "Extracting body for '#{link}'"
        assert_select('body') {|tag| body_tag = tag.first}
        new_links << extract_all_children(body_tag, "a").select{|e| e.attributes["href"]}.map{|e| e.attributes["href"].gsub("&amp;","&")}
    
        # flatten out the arrays
        new_links.flatten!
        # do not process anything twice
        new_links = new_links - links
        # kick out external links
        new_links.reject!{|x| x.include? "http://"}
        # kick out js links
        new_links.reject!{|x| (x=~/\#$/)}
      end
    end
  end

  # probably not valid any more
  # 
  # def test_items
  #   ['cs', 'en'].each do |lang|
  #     get_via_redirect home_path(:language_code => lang)
  #     shown_menu_items = []
  #     get_via_redirect home_path(:language_code => lang)
  #     menu_tag = nil
  #     assert_select 'div#menu ul' do |tag|
  #       menu_tag = tag.first
  #     end
  #     asel = HTML::Selector.new "li"
  #     shown_menu_items = []
  #     for link in extract_all_children(menu_tag, "li")
  #       id = link.attributes["id"]
  #       assert id =~ /menu_item_(\d+)/, "LI id [#{id}] not a menu item"
  #       shown_menu_items << MenuItem.find($1.to_i)
  #     end
  #     db_menu_items = MenuItem.find(:all, :conditions => ["language_id = ?", Language.find_by_code(lang).id])
  #     assert_equal db_menu_items.to_set, shown_menu_items.to_set
  #   end
  # end

  # either completely redo - or forget it!
  # 
  # def test_click_items
  #   links = []
  #   ['cs','en'].each do |lang|
  #     get_via_redirect home_path(:language_code => lang)
  #     menu_tag = nil
  #     assert_select '#menu_left' do |tag|
  #       menu_tag = tag.first
  #     end
  #     found_links = extract_all_children(menu_tag, "a")
  #     for link in found_links
  #       href = link.attributes["href"]
  #       text = link.children.first.content
  #       links << [href, text]
  #     end
  #   end
  #   links.uniq!
  #   for link, menuitem in links do
  #     # p "linking to '#{menuitem}'[#{link}]"
  #     get_via_redirect link
  #     assert_response :success, "Failed to open '#{menuitem}'[#{link}]"
  #   end
  # end

end
