require File.dirname(__FILE__) + '/../test_helper'

class HeadlineTest < ActiveSupport::TestCase

  def setup
    @languages = [ languages(:czech), languages(:english) ]
  end

  def test_unexpired?
    assert_equal true,  headlines(:en_first_unexpired).unexpired?
    assert_equal false, headlines(:en_expired).unexpired?
  end
  
  def test_find_unexpired
    language = languages(:czech)
    Headline.find_unexpired(language).each do |headline|
      assert_equal true, headline.unexpired?
      assert_equal language, headline.language
    end
  end
  
  def test_find_newest
    language = languages(:english)
    newest = Headline.find_newest(language)
    assert 3 <= newest.length, "Should contain 3 or more newest '#{language.code}' headlines"
    
    newest.each do |headline|
      assert_equal language, headline.language
    end      
    
    newest[0].updated_at >= newest[1].updated_at
    newest[1].updated_at >= newest[2].updated_at
  end
  
  def test_annotation
    assert_equal "Novinka o psech zacina takhle.", headlines(:dognews_w_annotation).annotation
    assert_equal "Text clanku o psech.", headlines(:dognews).annotation
  end
  
end
