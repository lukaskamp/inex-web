ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

require 'test_help'
require 'active_resource/http_mock'
require 'test/mock_resources'


class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include AuthenticatedTestHelper

  if not const_defined? 'INITIALIZED_HELPER'
    USERS_TO_TEST = [ nil, 'admin']
    LANGUAGES = [ 'cs', 'en']
    INITIALIZED_HELPER = true
  end

  # Cycles through all users, every user is logged in
  # and then the test is runned for every language, passing
  # its code as a block parameter

  def for_all_langs
    LANGUAGES.each do |lang|
      RAILS_DEFAULT_LOGGER.debug "Testing in language '#{lang}'"
      yield(lang)
    end
  end

  def for_all_users( &block )
    USERS_TO_TEST.each do |user|
      login_as user
      RAILS_DEFAULT_LOGGER.debug "Testing for user '#{user}'"
      yield
    end
  end

  def for_all_users_and_langs( &block )
    USERS_TO_TEST.each do |user|
      login_as user
      LANGUAGES.each do |lang|
        RAILS_DEFAULT_LOGGER.debug "Testing in language '#{lang}' and for user '#{user}'"
        yield(lang)
      end
    end
  end

  def extract_all_children(root, tag)
    return [] unless HTML::Tag === root
    asel = HTML::Selector.new(tag)
    links = asel.select(root)
    for child in root.children
      links << extract_all_children(child, tag)
    end
    links.flatten
  end

  def assert_invalid( record, invalid_fields = [])
    assert_equal false, record.valid?, "Record #{record} is supposed to be invalid"
    invalid_fields.each do |field|
      assert_not_nil record.errors[field], "#{field} in #{record} is expected to be invalid"
    end
  end

  def assert_not_empty(object)
    assert_equal false, object.empty?, "#{object} shouldn't be empty"
  end

end
