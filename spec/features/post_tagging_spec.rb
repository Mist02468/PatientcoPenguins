require "json"
require "selenium-webdriver"
require_relative "../testCommonFunctions.rb"
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
    @driver = TestCommonFunctions.login(@base_url, @driver)
    
    @driver.find_element(:link, "Create Post").click
    
    @driver.find_element(:id, "postTextField").clear
    @driver.find_element(:id, "postTextField").send_keys "test post"
    
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:id, "tag_name-error").text).should == "Please enter a tag" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "tag tag"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:id, "tag_name-error").text).should == "Please enter a tag without spaces" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag1"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    
    verify { (@driver.find_element(:id, "postTextField").text).should == "test post" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag1"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    
    verify { (@driver.find_element(:id, "postTextField").text).should == "test post" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag2"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//li[2]").text).should == "testTag2" }
    
    verify { (@driver.find_element(:id, "postTextField").text).should == "test post" }
    
    @driver.find_element(:id, "tag_name").clear
    @driver.find_element(:id, "tag_name").send_keys "testTag3"
    @driver.find_element(:name, "commit").click
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//li[2]").text).should == "testTag2" }
    verify { (@driver.find_element(:xpath, "//li[3]").text).should == "testTag3" }
    
    verify { (@driver.find_element(:id, "postTextField").text).should == "test post" }
    
    @driver.find_element(:xpath, "(//input[@name='commit'])[3]").click
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//li[2]").text).should == "testTag3" }
    
    verify { (@driver.find_element(:id, "postTextField").text).should == "test post" }
    
    @driver.find_element(:css, "#postForm > input[name=\"commit\"]").click
    
    verify { (@driver.find_element(:css, "p.post").text).should == "test post" }
    verify { (@driver.find_element(:css, "li.tag").text).should == "testTag1" }
    verify { (@driver.find_element(:xpath, "//li[2]").text).should == "testTag3" }
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
