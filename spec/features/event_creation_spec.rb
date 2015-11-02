require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "EventCreationSpec" do

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
  
  it "test_event_creation_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    @driver.find_element(:link, "Create Event").click
    
    uniqueTopicName = DateTime.new
    @driver.find_element(:id, "event_topic").clear
    @driver.find_element(:id, "event_topic").send_keys "Test Event " + uniqueTopicName.to_s
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "datetime_month")).select_by(:text, "December")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "datetime_day")).select_by(:text, "25")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "datetime_hour")).select_by(:text, "07")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "datetime_minute")).select_by(:text, "35")
    @driver.find_element(:name, "commit").click
    
    verify { (@driver.find_element(:css, "p").text).should == "Event Topic: " + "Test Event " + uniqueTopicName.to_s }
    verify { (@driver.find_element(:xpath, "//p[2]").text).should == "Event Time: 2015-12-25 07:35:00 UTC" }
    verify { (@driver.find_element(:xpath, "//p[3]").text).should == "Event Host: GT Capstone" }
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
