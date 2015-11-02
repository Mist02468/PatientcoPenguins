require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "LoginLogoutSpec" do

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
  
  it "test_login_logout_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    #uncomment these once header is added to the home feed page
    #verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    #verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    @driver.find_element(:link, "View Profile").click
    verify { (@driver.find_element(:xpath, "//font[4]").text).should == "gtcscapstone@gmail.com" }
    verify { (@driver.find_element(:css, "font").text).should == "GT" }
    verify { (@driver.find_element(:xpath, "//font[2]").text).should == "Capstone" }
    
    @driver.get(@base_url + "/access/logout")
    (@driver.current_url).should == @base_url + "access/login"
    @driver.get(@base_url + "/post/new")
    (@driver.current_url).should == @base_url + "access/login"
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
