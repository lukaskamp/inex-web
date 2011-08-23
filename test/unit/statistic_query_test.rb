require 'test/test_helper'

class StatisticQueryTest < ActiveSupport::TestCase

  def setup
    commons = { :field => 'rating' }
    @all = [
        RatingChart.new, 
        @dynamic_rating = RatingChart.new(commons.update(:term => { :type => "RecentYear" })),
        @static_rating = RatingChart.new(commons.update(:term => { :type => "StaticTerm", :to => Date.today, :from => Date.today })),
        @from_x_rating = RatingChart.new(commons.update(:term => { :type => "FromXTillNow", :from => Date.today })),
        @summary = SummaryChart.new(commons.update(:term => { :type => "RecentYear" })),
     ]
  end

  def test_type_field
    assert_equal 'RatingChart', @dynamic_rating.type
    assert_equal 'SummaryChart', @summary.type
  end

  def test_validation
    @all.map { |chart| assert_valid chart }    
  end
  
  def test_save
    @all.each do |chart|
      chart.save!
      loaded = StatisticQuery.find(chart.id)      
      assert_equal chart, loaded      
      assert loaded.valid?
      assert_not_nil loaded.google_chart_url
    end
  end  
  
  def test_url_for_web
    @dynamic_rating.save!
    assert_equal "/cs/chart/#{@dynamic_rating.id}", @dynamic_rating.url_for_web
  end
  
  def test_valid_subclass?
    assert_equal false, StatisticQuery.valid_subclass?('undefined')
    assert StatisticQuery.valid_subclass?(RatingChart)    
    assert StatisticQuery.valid_subclass?(YesNoChart)    
    assert StatisticQuery.valid_subclass?(SummaryChart)    
    assert_equal false, StatisticQuery.list_subclasses.empty?
  end
  
end
