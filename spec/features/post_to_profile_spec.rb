require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "PostToProfileSpec" do

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

  it "test_post_to_profile_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Post").click
    
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "Hello"
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    
    @driver.find_element(:link, "GT Capstone").click
    verify { (@driver.find_element(:xpath, "//font[4]").text).should == "gtcscapstone@gmail.com" }
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
