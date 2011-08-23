require 'test_helper'

class SpecialArticleTest < ActiveSupport::TestCase
  
  def test_survey
    special = special_articles(:survey_intro)
    inczech = SpecialArticle.find_by_key(special.key, languages(:czech))
    # assert that the czech article and the special article have a common meta
    assert_equal special.meta_article, inczech.meta_article
  end
  
end
