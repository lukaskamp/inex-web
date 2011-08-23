require 'test/test_helper'

class PublicControllerTest < ActionController::TestCase

  def assert_article_resolves(language_code, path, article)
    get :resolve_path, :language_code => language_code, :path => path
    assert_equal article, assigns(:article)
  end
  
  def test_resolver
    assert_article_resolves 'cs', 'oinexu', articles(:cs_about_inex)
    assert_article_resolves 'en', 'oinexu', nil
    assert_article_resolves 'cs', '/oinexu', articles(:cs_about_inex)
    assert_article_resolves 'cs', 'oinexu_', nil
  end
    
end
