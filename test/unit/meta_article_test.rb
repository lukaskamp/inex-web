require 'test_helper'

class MetaArticleTest < ActiveSupport::TestCase

  def test_meta_creation
    # we should have a meta dogs/psi
    meta = articles(:dogs).meta_article
    assert_not_nil meta
    # unlink as langversion
    articles(:dogs).remove_myself_as_language_version
    # no meta now
    new_meta = articles(:dogs).meta_article
    assert_nil new_meta
    # force a meta
    new_meta = articles(:dogs).meta_article!
    assert_not_nil new_meta
    # it has to be a different one
    assert_not_equal meta, new_meta
  end
end
