require 'test/test_helper'

class BuiltinTextTest < ActiveSupport::TestCase

  def setup
    @czech = languages(:czech)
    @english = languages(:english)
  end
  
  def test_bt_from_language
    assert_equal builtin_texts(:en_vodka_fun, :en_dogma).to_set, @english.builtin_texts.to_set
  end

  def test_get_text
    assert_equal builtin_texts(:en_vodka_fun).body, BuiltinText.get_text('vodka_fun',@english)
    assert_equal "", BuiltinText.get_text('non_existing_label',@english)
  end
  
  def test_find_by_name
    assert_equal builtin_texts(:en_vodka_fun), BuiltinText.find_by_name('vodka_fun',@english)
    assert_equal nil, BuiltinText.find_by_name('non_existing_label',@english)
  end
  
  def test_language_versions
    assert_equal [['en',builtin_texts(:en_vodka_fun).body]], builtin_texts(:cs_vodka_fun).other_language_versions
    assert_equal [['cs',builtin_texts(:cs_vodka_fun).body]], builtin_texts(:en_vodka_fun).other_language_versions
    assert_equal [], builtin_texts(:en_dogma). other_language_versions
  end
  
  def test_uniqueness
    BuiltinText.delete_all

    original  = { :name => 'duplicate_key', :body => 'neco', :language => @czech }
    duplicate = { :name => 'duplicate_key', :body => 'neco jineho', :language => @czech }
    same_code_other_language = { :name => 'duplicate_key', :body => 'something', :language => @english }
    
    assert_equal true, BuiltinText.new(original).save, 
                'Failed to save valid text'

    assert_equal false, BuiltinText.new(duplicate).save, 
                'Duplicate text saved unexpectedly'

    assert_equal true, BuiltinText.new(same_code_other_language).save, 
                'Uniqueness constraint not within language_id scope'
  end

end
