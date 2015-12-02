require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "ProfileSpec" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://localhost:3000/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_profile_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "View Profile").click
    
    verify { (@driver.find_element(:css, "font").text).should == "GT" }
    verify { (@driver.find_element(:xpath, "//font[2]").text).should == "Capstone" }
    verify { (@driver.find_element(:xpath, "//font[3]").text).should == "Greater Atlanta Area" }
    verify { (@driver.find_element(:xpath, "//font[4]").text).should == "gtcscapstone@gmail.com" }
    verify { (@driver.find_element(:xpath, "//font[5]").text).should == "Computer Software" }
    verify { (@driver.find_element(:xpath, "//font[6]").text).should == "Georgia Institute of Technology" }
    verify { (@driver.find_element(:xpath, "//font[7]").text).should == "Teaching Assistant" }
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
