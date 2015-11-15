class EventController < ApplicationController

	before_action :confirm_logged_in
  
  def new
    @event = Event.new
    if params[:tag].present?
        @event.topic = params[:currentEventTopic]
        addTag()
    elsif params[:tagToRemove].present?
        @event.topic = params[:currentEventTopic]
        removeTag()
    else
        @tagsToAdd = []
    end
  end
  
  def create
	@event = Event.new(event_params)
	@event.startTime = DateTime.civil(params[:datetime][:year].to_i, params[:datetime][:month].to_i, params[:datetime][:day].to_i, params[:datetime][:hour].to_i, params[:datetime][:minute].to_i, 0, Time.zone.formatted_offset)
    @event.host = User.find(session[:user_id])
	
	@tagsToAdd = params[:tagsToAdd].split(" ")
	@tagsToAdd.each do |t|
		@event.tags << createTag(t)
	end
	@event.doc_link = createGoogleDoc(@event)
	@event.hangout_view_link = createGoogleHangoutOnAir(@event)
	if @event.save!
      redirect_to action: "show", :id => @event.id
    else
      redirect_to action: 'new'
    end
  end
  
  def show
    @event = Event.find(params[:id])
    @user  = User.find(session[:user_id])
    if not @event.endTime.nil?
        @status = 'finished'
    elsif not @event.hangout_join_link.nil?
        @status = 'live'
    else
        @status = 'scheduled'
    end
  end
  
  def start
    @event = Event.find(params[:id])
   
    driver = joinHangout('https://www.youtube.com/my_live_events', @event)
  
    driver.find_element(:xpath, "//div[@id=':sd.Pt']/div/div[2]/div").click #click the add people icon
    boxWithJoinLink = driver.find_element(:id, ":ut.vt").click #find the box with the join link
    joinLink = boxWithJoinLink[:value]
    
    driver.find_element(:id, ":uu.Ji").click #click the close button
    driver.find_element(:id, ":t0.ak").click #click Start Broadcast
    driver.find_element(:id, ":vn.Hk").click #click Okay
    
    driver.quit

    @event.hangout_join_link = joinLink
    @event.save!

    redirect_to action: "show", :id => @event.id
  end
  
  def stop
    @event = Event.find(params[:id])
    
    driver = joinHangout(@event.hangout_join_link, @event)
    driver.find_element(:id, ":t4.ak").click #click Stop Broadcast
    
    @event.endTime = DateTime.current
    @event.save!
    
    redirect_to action: "show", :id => @event.id
  end
  
  private
  def event_params
    params.require(:event).permit(:topic)
  end
  
  def tag_params
	params.require(:tag).permit(:name)
  end
  
  def joinHangout(link, event = nil)
    require 'selenium-webdriver'
    
    profile = Selenium::WebDriver::Firefox::Profile.new()
    profile['plugin.state.npgoogletalk'] = 2
    profile['plugin.state.npo1d']        = 2
    driver = Selenium::WebDriver.for(:firefox, :profile => profile)
    
    driver.get(link)
    driver.find_element(:id, "Email").clear
    driver.find_element(:id, "Email").send_keys "gtcscapstone@gmail.com"
    driver.find_element(:id, "next").click
    
    driver.find_element(:id, "Passwd").clear
    driver.find_element(:id, "Passwd").send_keys get_secret('GoogleAccountPassword')
    driver.find_element(:id, "signIn").click
    
    if not event.nil?
        driver.find_element(:xpath, '//*[@data-video-id="' + event.hangout_view_link + '"]').click
    end
    
    sleep(5)
    present = driver.find_elements(:css, "div.a-X-fe")
    if present.length > 0
        driver.find_element(:css, "div.a-X-fe").click #click the check box
        driver.find_element(:id, ":t0.Tj").click #click Okay I get it button
        driver.find_element(:id, ":t1.Et").click #click Join
    end
    return driver
  end
  
  def createGoogleDoc(event)
	require 'google/api_client'
	
	serviceAccount_email = '54678097976-94j19m7hap7c8k0jkii8gol8bg2hltco@developer.gserviceaccount.com'
	serviceAccount_PKCS12_filePath = Rails.root.join('config', 'Capstone Project-1c7361b30ae2.p12')
	
	key = Google::APIClient::PKCS12.load_key(serviceAccount_PKCS12_filePath, get_secret('GoogleKeyPassword'))
    asserter = Google::APIClient::JWTAsserter.new(serviceAccount_email, 'https://www.googleapis.com/auth/drive', key)
    client = Google::APIClient.new()
    client.authorization = asserter.authorize()
    
    service = client.discovered_api('drive', 'v2')
    file = service.files.insert.request_schema.new({
		   'title' => event.topic,
		   'mimeType' => 'application/vnd.google-apps.document'})
	file.parents = [{'id' => '0B2PZURw_M0AlfkhISFdZQXgxd0RnTzVERmJxZ19ndDZVQV81T0tZTVpoWGtQYV9oYkdEYjA'}]
    
    result = client.execute(
             :api_method => service.files.insert,
             :body_object => file)
             
    if result.status == 200
		puts 'Successful'
		return JSON.parse(result.response.env['body'])['id']
		#pp JSON.parse(client.execute(:api_method => service.files.list).env['body'])
		#pp client.execute(:api_method => service.files.list)
    else
		puts 'Unsuccessful'
	end
  end
  
  def createGoogleHangoutOnAir(event)
	require 'capybara/poltergeist'
    require 'capybara/rspec'
    require 'capybara/rails'

    Capybara.default_max_wait_time = 5
    session = Capybara::Session.new(:poltergeist)
    
    session.visit('https://accounts.google.com/ServiceLogin?passive=true&continue=https%3A%2F%2Fwww.youtube.com%2Fsignin%3Faction_handle_signin%3Dtrue%26app%3Ddesktop%26feature%3Dredirect_login%26next%3D%252Fmy_live_events%253Faction_create_live_event%253D1%26hl%3Den&service=youtube&uilel=3&hl=en')
    session.fill_in('Email', :with => 'gtcscapstone@gmail.com')
    session.click_button('next')
    
    session.fill_in('Passwd', :with => get_secret('GoogleAccountPassword'))
    session.click_button('signIn')
    # TODO, make these fail better
    #session.save_screenshot('rightAfterSignIn.png', :full => true)
    session.find('#title') # let the next page load
    #session.save_screenshot('afterSFindWaiting.png', :full => true)

    session.fill_in('title', :with => event.topic)
    script = 'document.getElementsByClassName("yt-uix-form-input-text time-range-date time-range-compact")[0].removeAttribute("readonly"); document.getElementsByClassName("yt-uix-form-input-text time-range-date time-range-compact")[0].value = "' + event.startTime.in_time_zone.strftime("%b %e, %Y") + '";'
    session.execute_script(script)
    session.find(:xpath, '//input[@class="yt-uix-form-input-text"]').set(event.startTime.in_time_zone.strftime("%l:%M %p"))
    session.select('Unlisted', :from => 'privacy')
    session.first(:xpath, '//*[@class="save-cancel-buttons"]').click
    
    #session.save_screenshot('rightAfterCreate.png', :full => true)
    session.find('#creator-subheader-text') # let the next page load
    #session.save_screenshot('afterCFindWaiting.png', :full => true)
    
    #for debugging: session.save_screenshot('here1.png', :full => true)
    
    links = session.all('a', :text => event.topic)
    if links.count() == 1
        link = links.first()
    else
        numPrevSameTopicEvents = Event.where(topic: event.topic).where('startTime >= :today_date_time', {today_date_time: DateTime.current.utc}).where('startTime < :new_event_date_time', {new_event_date_time: event.startTime.utc}).count
        j = 0
        links.each do |l|
            if j == numPrevSameTopicEvents
                link = l
                break
            end
            j += 1
        end
    end
    
    address = link[:href].split('=') # gives for example /watch?v=tuV0fqh5jgQ, will have to use as https://www.youtube.com/watch?v=tuV0fqh5jgQ and we'll only store tuV0fqh5jgQ 
    return address[1]
  end
 
end
