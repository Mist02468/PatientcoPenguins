require "json"
require "selenium-webdriver"
include RSpec::Expectations

describe "PostTagging" do

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
  
  it "test_post_tagging" do
    @driver.get(@base_url + "access/login")
    @driver.find_element(:css, "img[alt=\"Sign in 8b25c2de2af5f6c13c47d836fb64dfd43fbf9e587c70b15180e565848703760a\"]").click
    @driver.find_element(:id, "session_key-oauth2SAuthorizeForm").clear
    @driver.find_element(:id, "session_key-oauth2SAuthorizeForm").send_keys "gtcscapstone@gmail.com"
    @driver.find_element(:id, "session_password-oauth2SAuthorizeForm").clear
    @driver.find_element(:id, "session_password-oauth2SAuthorizeForm").send_keys "foUrtesting"
    @driver.find_element(:name, "authorize").click
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag1"
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    verify { (@driver.find_element(:css, "td").text).should == "testTag1" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag2"
    @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    verify { (@driver.find_element(:css, "td").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//tr[2]/td").text).should == "testTag2" }
    
    @driver.find_element(:id, "post_text").clear
    @driver.find_element(:id, "post_text").send_keys "test post"
    @driver.find_element(:name, "commit").click
    
    verify { (@driver.find_element(:css, "p").text).should == "Post: test post" }
    verify { (@driver.find_element(:css, "td").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//tr[2]/td").text).should == "testTag2" }
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
