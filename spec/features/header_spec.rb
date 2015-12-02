require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "HeaderSpec" do

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

  it "test_header_spec" do
    @driver.get(@base_url + "/access/login")
    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    @driver = TestCommonFunctions.login(@base_url, @driver)

    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Post").click
    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "Whee I posted things."
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    @driver.find_element(:id, "Pronnect").click
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "View Profile").click
    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
    
    @driver.find_element(:id, "Pronnect").click
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Event").click
    (@driver.title).should == "Pronnect"
    verify { (@driver.find_element(:id, "Pronnect").text).should == "Pronnect" }
    verify { (@driver.find_element(:id, "RevenueCycle").text).should == "Revenue Cycle" }
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
