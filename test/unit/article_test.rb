require 'test/test_helper'

class ArticleTest < ActiveSupport::TestCase

  def setup
    @english = languages(:english)
    @czech = languages(:czech)
    @dogs = articles(:dogs)
    @cats = articles(:cats)
    @psi = articles(:psi)
  end

  def test_articles_from_language
    assert languages(:english).articles.include?(@dogs), "Relation with languages does not work"
    assert languages(:english).articles.include?(@cats), "Relation with languages does not work"
  end
  
  def test_meta_article
    dogs_ma = @dogs.meta_article
    assert_not_nil dogs_ma, "Meta article of versioned article dogs is nil"
    new_dogs_ma = @dogs.meta_article!
    assert_equal dogs_ma, new_dogs_ma, "Meta article of already versioned article dogs has changed"

    cats_ma = @cats.meta_article
    assert_nil cats_ma, "Meta article of unversioned article cats is not nil"
    new_cats_ma = @cats.meta_article!
    assert_not_nil new_cats_ma, "Meta article of article cats not created"
  end


  def test_get_in_language
    assert_equal @dogs, Article.get_in_language(@dogs.id, @english), "Wrong article found"
    assert_equal @psi, Article.get_in_language(@dogs.id, @czech), "Wrong alternative article found"
    assert_equal @cats, Article.get_in_language(@cats.id, @english), "Wrong article found"
    assert_nil Article.get_in_language(@cats.id, @czech), "Cats shouldn't have czech alternative"
  end
  
  def test_language_version
	  czech = @psi
	  english = @dogs
	  assert_equal czech,czech.language_version(@czech)
	  assert_equal english,english.language_version(@english)
	  assert_equal czech,english.language_version(@czech)
	  assert_equal english,czech.language_version(@english)
	end
   
  def test_language_version_editing
    # check correct match in the beginning
	  assert_equal @dogs,@psi.language_version(@english)
	  assert_equal @psi,@dogs.language_version(@czech)
	  first_meta = @dogs.meta_article_id
	  # remove dogs' relation
	  @dogs.remove_myself_as_language_version
	  assert_nil @psi.language_version(@english)
	  assert_nil @dogs.language_version(@czech)
	  # associate dogs as psi@en
	  @psi.add_language_version(@dogs)
	  assert_equal @dogs,@psi.language_version(@english)
	  assert_equal @psi,@dogs.language_version(@czech)
	  second_meta = @dogs.meta_article_id
	  # remove both relations
	  @psi.remove_myself_as_language_version
	  @dogs.remove_myself_as_language_version
	  assert_nil @psi.language_version(@english)
	  assert_nil @dogs.language_version(@czech)
	  # associate psi as dogs@cs
	  @dogs.add_language_version(@psi)
	  assert_equal @dogs,@psi.language_version(@english)
	  assert_equal @psi,@dogs.language_version(@czech)
	  third_meta = @dogs.meta_article_id
	  # verify that the meta's the same each time
	  assert_equal first_meta, second_meta
	  assert_not_equal third_meta, second_meta
  end
  
  # Test for all authored models
  def test_authored_fields
    admin = users(:admin)
    Article.find(:all).each do |article|
      assert_equal admin, article.created_by
      assert_equal admin, article.updated_by      
    end
  end

end
