require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
include RSpec::Expectations

describe "HomeFeedPostsWithTagSpec" do

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
  
  it "test_home_feed_posts_with_tag_spec" do
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    uniquePostText = DateTime.new

    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Post").click
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag1"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "This should not appear " + uniquePostText.to_s + "."
    @driver.find_element(:css, "#postForm > input[name=\"commit\"]").click
    
    @driver.find_element(:id, "Pronnect").click
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Post").click
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag2"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "This should appear 1 " + uniquePostText.to_s + "."
    @driver.find_element(:css, "#postForm > input[name=\"commit\"]").click
    
    @driver.find_element(:id, "Pronnect").click
    menu = @driver.find_element(:id, 'fl_menu')
    @driver.action.move_to(menu).perform
    @driver.find_element(:link, "Create Post").click
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag2"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "This should appear 2 " + uniquePostText.to_s + "."
    @driver.find_element(:css, "#postForm > input[name=\"commit\"]").click
    
    @driver.find_element(:link, "testTag2").click
    
    verify { (@driver.find_element(:css, "h1").text).should == "Content Tagged With testTag2" }
    verify { (@driver.find_element(:link, "This should appear 2 " + uniquePostText.to_s + ".").text).should == "This should appear 2 " + uniquePostText.to_s + "." }
    verify { (@driver.find_element(:link, "This should appear 1 " + uniquePostText.to_s + ".").text).should == "This should appear 1 " + uniquePostText.to_s + "." }
    
    verify { element_present?(:link, "This should not appear " + uniquePostText.to_s + ".").should == false } 
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
