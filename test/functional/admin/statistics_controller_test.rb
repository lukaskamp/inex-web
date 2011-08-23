require 'test/test_helper'
require 'test/functional/admin/active_scaffold_read_only_tester'
require 'test/functional/admin/authoring_fields_tester'


class Admin::StatisticsControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldReadOnlyTester

  def test_create_query
    get :create_chart, :language_code => 'cs'
    assert_template 'create_chart'
    assert_response :success
  end 
  
  def test_render_rating_chart
    chart = { :type => 'RatingChart',
               :field => 'rating',
               :term => { :type => 'StaticTerm', :from => Date.today, :to => Date.today } }    
    send_and_assert_form_updated(chart)
  end
  
  def test_render_sums_chart
    chart = { :type => 'SummaryChart',
               :field => 'knowhow',
               :term => { :type => 'RecentYear'} }    
    send_and_assert_form_updated(chart)
  end  
      
  protected 
  
  def item
    chart = RatingChart.new(:field => 'rating', :term => { :type => 'RecentYear' })
    chart.save!
    chart
  end
  
  private
  
  def send_and_assert_form_updated(chart)
    xhr :post, :render_chart, :chart => chart, :language_code => 'cs'
    assert_response :success
    assert_select_rjs :replace_html, 'chart_container'
  end

end
