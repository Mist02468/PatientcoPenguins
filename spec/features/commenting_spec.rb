require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "CommentingSpec" do

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
  
  it "test_commenting_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    @driver.find_element(:link, "Create Post").click
    
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "test post"
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    
    @driver.find_element(:id, "post_text").clear
    @driver.find_element(:id, "post_text").send_keys "test comment 1"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "td").text).should == "test comment 1" }
    verify { (@driver.find_element(:xpath, "(//a[contains(text(),'GT Capstone')])[2]").text).should == "GT Capstone" }
    
    @driver.find_element(:id, "post_text").clear
    @driver.find_element(:id, "post_text").send_keys "test comment 2"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:xpath, "//tr[2]/td").text).should == "test comment 2" }
    verify { (@driver.find_element(:xpath, "(//a[contains(text(),'GT Capstone')])[3]").text).should == "GT Capstone" }
    verify { (@driver.find_element(:css, "p.post").text).should == "test post" }
    
    @driver.find_element(:id, "Pronnect").click
    @driver.find_element(:link, "Create Post").click
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "another test post"
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    
    @driver.find_element(:id, "post_text").clear
    @driver.find_element(:id, "post_text").send_keys "another test comment 1"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "td").text).should == "another test comment 1" }
    verify { (@driver.find_element(:css, "p.post").text).should == "another test post" }
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
