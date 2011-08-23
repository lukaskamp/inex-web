require 'test/test_helper'

class MenuItemTest < ActiveSupport::TestCase

  def test_children_association
    assert_equal 0, menu_items(:empty_grocery).children.length
    assert_equal 2, menu_items(:grocery).children.length
    
    children = menu_items(:grocery).children
    assert children[0] == menu_items(:fruits), "Fruits not under Food or on a wrong position."
    assert children[1] == menu_items(:vegetables), "Vegetables not under Food or on a wrong position."
  end
  
  def test_parent_association
    assert menu_items(:grocery).parent.nil?
    assert menu_items(:empty_grocery).parent.nil?
    assert menu_items(:fruits).parent == menu_items(:grocery)
    assert menu_items(:vegetables).parent == menu_items(:grocery)
    assert menu_items(:carrot).parent == menu_items(:vegetables)
  end
  
  def test_root_items
    items = MenuItem.root_menu_items languages(:english)
    assert_equal 2, items.length
    assert_equal items[0], menu_items(:grocery)
    assert_equal items[1], menu_items(:empty_grocery)
  end
  
  
end
