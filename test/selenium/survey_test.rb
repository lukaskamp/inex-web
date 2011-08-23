require "selenium"
require "test/unit"

class survey_test < Test::Unit::TestCase
  def setup
    @verification_errors = []
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new("localhost", 4444, "*chrome", "http://change-this-to-the-site-you-are-testing/", 10000);
      @selenium.start
    end
    @selenium.set_context("test_survey_test")
  end
  
  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
  end
  
  def test_survey_test
    @selenium.open "/cs/fn/survey"
    @selenium.type "survey_lastname", "Kuba"
    @selenium.type "survey_firstname", "Kuba"
    @selenium.type "survey_email", "jakub.hozak@gmail.com"
    @selenium.type "survey_age", "27"
    @selenium.type "survey_projectcountry", "Island"
    @selenium.type "survey_project", "ISL1213"
    @selenium.click "survey_reason_poznání_jiné_kultury"
    @selenium.click "survey_howknow_na_internetu"
    @selenium.select "survey_findinex", "label=1 - Výborné"
    @selenium.select "survey_findproject", "label=3 - Průměrné"
    @selenium.select "survey_findapplication", "label=1 - Výborné"
    @selenium.type "survey_findcomment", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.select "survey_ratecommunication", "label=2 - Dobré"
    @selenium.select "survey_rateapplication", "label=2 - Dobré"
    @selenium.type "survey_ratecomment", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.select "survey_projwork", "label=3 - Průměrné"
    @selenium.select "survey_projstudy", "label=1 - Výborné"
    @selenium.select "survey_projgroup", "label=1 - Výborné"
    @selenium.select "survey_projleisure", "label=2 - Dobré"
    @selenium.select "survey_projleader", "label=1 - Výborné"
    @selenium.select "survey_projaccomodation", "label=2 - Dobré"
    @selenium.select "survey_projfood", "label=2 - Dobré"
    @selenium.select "survey_projhygiene", "label=4 - Špatné"
    @selenium.type "survey_projcomment", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.select "survey_collcommunication", "label=2 - Dobré"
    @selenium.select "survey_collconflict", "label=3 - Průměrné"
    @selenium.select "survey_collinfo", "label=2 - Dobré"
    @selenium.type "survey_collcomment", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.click "survey_wasgood_0"
    @selenium.click "survey_wouldrecommend_0"
    @selenium.type "survey_whynot", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.select "survey_rating", "label=1 - Výborné"
    @selenium.type "survey_visa", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.type "survey_transport", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.click "survey_goagain_0"
    @selenium.click "survey_recommendtofriends_0"
    @selenium.click "survey_wouldhelp_0"
    @selenium.type "survey_comments", "zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska zkouska"
    @selenium.type "survey_newsletter", "aa"
    @selenium.click "survey_submit"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_text_present("Děkujeme za vyplnění dotazníku.")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end
