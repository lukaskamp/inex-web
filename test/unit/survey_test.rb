require 'test/test_helper'

class SurveyTest < ActiveSupport::TestCase

  def setup
    @valid = { :lastname => 'Moucka', :firstname => 'Josef',
               :projectcountry => 'Rusko', :project => 'Bourani Moskvy',
               :email => 'nikdo@rusko.ru',
               :age => 15,
               :rating => 4,
               :findinex => 2 }
  end

  def test_validation
    wrong_age = { :age => -5 }

    assert Survey.new(@valid).save
    assert_equal false, Survey.new(@valid.update(wrong_age)).save

    Survey::EVALUATION_ATTRIBUTES.each do |attribute|
      too_high = { attribute => 77 }
      too_low = { attribute => -1 }
      message = "Failed to validate #{attribute}"
      assert_equal false, Survey.new(@valid.update(too_low)).save, message
      assert_equal false, Survey.new(@valid.update(too_high)).save, message
    end
  end

  def test_long_test_fields
    survey = Survey.new(@valid)
    [ :whynot, :visa, :comments, :transport,
      :collcomment, :projcomment, :findcomment, :ratecomment
    ].each do |field|
      survey.send("#{field}=", "X" * 8000)
    end

    assert_valid survey
  end

  def test_to_csv
    @valid[:lastname] = '"Moucka, von Banhof"'
    csv = Survey.new(@valid).to_csv
    result = '"\'Moucka, von Banhof\'"'
    assert csv.start_with?(result)
  end

  def test_yes_no
    Survey::YES_NO_ATTRIBUTES.each do |field|
      @valid.update field => 1
      assert_valid Survey.new(@valid)
    end

  end

  def test_evaluation_statistics
    # sanity test
    assert_equal 100, Survey.count
    test_one_column_statistics('findinex')
    test_one_column_statistics('findproject')
  end

  def test_csv_export
    assert_not_nil Survey.find(:all).to_csv
  end

  private

  def test_one_column_statistics(column, options = { :grade_count => 6 } )
    counts = Survey.evaluation_statistics(column, 1.year.ago.to_date, Date.today )
    assert_equal options[:grade_count], counts.length, 'Wrong number of grades in statistics'

    # sum up number of the volunteers
    assert_equal 100, counts.map {|record| record[1] }.inject {|sum,count| sum + count }
  end

end
