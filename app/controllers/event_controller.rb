#controller for the event pages: new, create, show, start, stop, and error
class EventController < ApplicationController

    #make sure the user is logged in before showing them an event or allowing them to create, start, or stop one
    before_action :confirm_logged_in
  
    #initializes a new event object, keeping track of the topic and tags which the user has typed into the page thus far
    def new
        @event = Event.new
        #if new is being called because the user clicked the add tag button
        if params[:tag].present?
            @event.topic = params[:currentEventTopic]
            addTag()
        #if new is being called because the user clicked an x to remove one of the tags
        elsif params[:tagToRemove].present?
            @event.topic = params[:currentEventTopic]
            removeTag()
        #if new is being called because the user has just navigated to this page
        else
            @tagsToAdd = []
        end
    end
  
    #creates an event in our db after the user submits the form by clicking the create event button, also creates the Google Doc and Google Hangout on Air for this event
    def create
        #initialize a new event object with the parameters submitted, validated by event_params
        @event = Event.new(event_params)
        
        #combines the parameters from the year, month, day, hour, and minute fields to set the start time for this event
        @event.startTime = DateTime.civil(params[:datetime][:year].to_i, params[:datetime][:month].to_i, params[:datetime][:day].to_i, params[:datetime][:hour].to_i, params[:datetime][:minute].to_i, 0, Time.zone.formatted_offset)
        #sets the host to be the user which is currently logged in
        @event.host = User.find(session[:user_id])
        #adds the tags to this event
        @tagsToAdd = params[:tagsToAdd].split(" ")
        @tagsToAdd.each do |t|
            @event.tags << createTag(t)
        end
        
        #creates a google doc and sets its identifier on this event
        @event.doc_link = createGoogleDoc(@event)
        #creates a google hangout and sets those identifiers on this event
        links = createGoogleHangoutOnAir(@event)
        if links != nil
            @event.hangout_view_link = links[0]
            @event.hangout_join_link = links[1]
            if @event.save!
                redirect_to action: "show", :id => @event.id #go to this new event's show page
            else
                redirect_to action: 'new' #upon failure, try again
            end
        end
    end
  
    #pulls the event and currently logged in user from our db, and determines the state of the event (whether finished, live, or scheduled) for the view to display
    def show
        @event = Event.find(params[:id])
        @user  = User.find(session[:user_id])
        
        #if the event's end time is set, it is finished
        if not @event.endTime.nil?
            @status = 'finished'
        #otherwise, if the event's actual start time is set, it is live
        elsif not @event.actualStartTime.nil?
            @status = 'live'
        #otherwise, if neither of those are set, the event is still just scheduled
        else
            @status = 'scheduled'
        end
    end
  
    #called when the host of an event presses the start event button, it screen scrapes to log into our google service account, pull up the hangout, and click the start broadcast button, upon success, sets the actual start time
    def start
        @event = Event.find(params[:id])
    
        begin 
            @driver = joinHangout(@event, true) #navigates through logging in and clicking the start hangout on air button
            sleep(40) #wait for google to prepare the hangout for broadcasting
            @driver.find_element(:xpath, '//div[contains(text(), "Start broadcast")]').click #start the broadcast
            @driver.find_element(:xpath, '//div[contains(text(), "OK")]').click #click OK on the popup
        rescue Exception => e
            showDebuggingErrorPage(e, @driver) #in case something goes wrong, note the exception and pass the driver so it can take a screenshot
            return
        end

        @event.actualStartTime = DateTime.current #now this event is live
        @event.save!

        redirect_to action: "show", :id => @event.id #stay on this page
    end
  
    #called when the host of an event presses the end event button, it screen scrapes to log into our google service account, pull up the hangout, and click the stop broadcast button, upon success, sets the end time
    def stop
        @event = Event.find(params[:id])
    
        begin
            @driver = joinHangout(@event, false) #navigates through logging in and joining the hangout on air
            @driver.find_element(:xpath, '//div[contains(text(), "Stop broadcast")]').click #stop the broadcast
        rescue Exception => e
            showDebuggingErrorPage(e, @driver) #in case something goes wrong, note the exception and pass the driver so it can take a screenshot
            return
        end
        
        @driver.quit
        if request.host_with_port != 'localhost:3000'
            @headless.destroy #if on the server, rather than being tested locally, also need to close the headless browser
        end
    
        @event.endTime = DateTime.current #now this event is finished
        @event.save!
    
        redirect_to action: "show", :id => @event.id #stay on this page
    end
  
    #when view displays the error page, this method gives it access to the exception message
    def error
        if params[:exceptionMessage].present? 
            @exceptionMessage = params[:exceptionMessage]
        end
    end
  
    private
  
    def event_params
        params.require(:event).permit(:topic) #page is allowed to set the topic field of a new event
    end
  
    def tag_params
        params.require(:tag).permit(:name) #page is allowed to set the name field of a new tag
    end
  
    #called by start and stop, uses selenium to screen scrape its way through logging into our google service account and starting or joining the google hangout on air
    def joinHangout(event, isStart)
        require 'selenium-webdriver'
    
        #if on the server, also need to use headless to start Xvfb
        if request.host_with_port != 'localhost:3000'
            require 'headless'
            @headless = Headless.new
            @headless.start
        end
    
        #need to specify the Firefox profile which selenium should use, since to get into a hangout, the browser needs google plugins
        #this is why capybara, poltergeist, and phantom js were not sufficient for this round of screen scraping
        profile = Selenium::WebDriver::Firefox::Profile.new()
        profile['plugin.state.npgoogletalk'] = 2
        profile['plugin.state.npo1d']        = 2
        @driver = Selenium::WebDriver.for(:firefox, :profile => profile)
        @driver.manage.timeouts.implicit_wait = 5 #wait up to 5 seconds for an expected element to appear
    
        if isStart
            @driver.get('https://www.youtube.com/my_live_events?filter=scheduled') #load the page with all the scheduled hangouts
        else
            @driver.get(event.hangout_join_link) #go to the link of the already started hangout
        end
    
        #since we aren't logged in, google will redirect us to login first
        @driver.find_element(:id, "Email").clear
        @driver.find_element(:id, "Email").send_keys "gtcscapstone@gmail.com"
        @driver.find_element(:id, "next").click
    
        @driver.find_element(:id, "Passwd").clear
        @driver.find_element(:id, "Passwd").send_keys get_secret('GoogleAccountPassword')
        @driver.find_element(:id, "signIn").click
    
        if isStart
            @driver.find_element(:xpath, '//*[@data-video-id="' + event.hangout_view_link + '"]').click #click the proper start hangout on air button
            sleep(5) #wait for it to open a new window
    
            #switch selenium to interacting with that new window
            openWindows = @driver.window_handles
            @driver.switch_to.window(openWindows[1])
        else
            sleep(10) #wait for the hangout to load
            @driver.find_element(:xpath, '//span[@role="checkbox"]').click #click the checkbox agreeing to google's terms
            @driver.find_element(:xpath, '//div[contains(text(), "Okay, got it!")]').click #click the okay button to close that pop-up
            @driver.find_element(:xpath, '//div[contains(text(), "Join")]').click #click the join button to enter the hangout
        end
        
        return @driver
    end
  
    #uses the google drive api to create a new google doc in our google service account's folder
    def createGoogleDoc(event)
        require 'google/api_client'
	
        serviceAccount_email = '54678097976-94j19m7hap7c8k0jkii8gol8bg2hltco@developer.gserviceaccount.com'
        serviceAccount_PKCS12_filePath = Rails.root.join('config', 'Capstone Project-1c7361b30ae2.p12')
	
        #authenticate ourselves to the api
        key = Google::APIClient::PKCS12.load_key(serviceAccount_PKCS12_filePath, get_secret('GoogleKeyPassword'))
        asserter = Google::APIClient::JWTAsserter.new(serviceAccount_email, 'https://www.googleapis.com/auth/drive', key)
        client = Google::APIClient.new()
        client.authorization = asserter.authorize()
    
        #setup the request, to the drive api, to insert a new document in our folder with its title being the event topic specified by the user
        service = client.discovered_api('drive', 'v2')
        file = service.files.insert.request_schema.new({
                                                        'title' => event.topic,
                                                        'mimeType' => 'application/vnd.google-apps.document'})
        file.parents = [{'id' => '0B2PZURw_M0AlfkhISFdZQXgxd0RnTzVERmJxZ19ndDZVQV81T0tZTVpoWGtQYV9oYkdEYjA'}]
    
        #make the request
        result = client.execute(
                                :api_method => service.files.insert,
                                :body_object => file)
             
        if result.status == 200
            return JSON.parse(result.response.env['body'])['id'] #get the document's identifier from the response
        else
            puts 'Unsuccessful'
        end
    end
  
    #uses capybara, poltergeist, and phantom js to screen scrape its way through logging into our google service account, filling in the google hangout on air creation form, and scraping the identifiers from the scheduled events page
    def createGoogleHangoutOnAir(event)
        require 'capybara/poltergeist'
        require 'capybara/rspec'
        require 'capybara/rails'

        Capybara.default_max_wait_time = 5 #wait up to 5 seconds for an expected element to appear
        @session = Capybara::Session.new(:poltergeist) #use poltergeist, which uses phantom js
    
        begin
            #go to the login page, where the google hangout on air creation page is in the redirect portion of this url
            @session.visit('https://accounts.google.com/ServiceLogin?passive=true&continue=https%3A%2F%2Fwww.youtube.com%2Fsignin%3Faction_handle_signin%3Dtrue%26app%3Ddesktop%26feature%3Dredirect_login%26next%3D%252Fmy_live_events%253Faction_create_live_event%253D1%26hl%3Den&service=youtube&uilel=3&hl=en')
            @session.fill_in('Email', :with => 'gtcscapstone@gmail.com')
            @session.click_button('next')
        
            @session.fill_in('Passwd', :with => get_secret('GoogleAccountPassword'))
            @session.click_button('signIn')
            @session.find('#title') #give time for the next page to load, you'll know you're there when you can find the title element

            #fill in google's form with the topic, date, and time specified by the user of our site
            @session.fill_in('title', :with => event.topic)
            script = 'document.getElementsByClassName("yt-uix-form-input-text time-range-date time-range-compact")[0].removeAttribute("readonly"); document.getElementsByClassName("yt-uix-form-input-text time-range-date time-range-compact")[0].value = "' + event.startTime.in_time_zone.strftime("%b %e, %Y") + '";'
            @session.execute_script(script) #need to remove the readonly attribute from the date and time field
            @session.find(:xpath, '//input[@class="yt-uix-form-input-text"]').set(event.startTime.in_time_zone.strftime("%l:%M %p"))
            @session.select('Unlisted', :from => 'privacy') #choose that the hangout on air should be unlisted, meaning it is not public, you can only access it with a link
            @session.first(:xpath, '//*[@class="save-cancel-buttons"]').click
        
            @session.find('#creator-subheader-text') #give time for the next page to load, you'll know you're there when you can find the creator subheader text element
        
            @links = @session.all('a', :text => event.topic) #find all links on this scheduled events page which have the event topic as their text
    
        rescue Exception => e
            showDebuggingErrorPage(e, @session) #in case something goes wrong, note the exception and pass the driver so it can take a screenshot
            return
        end
        
        if @links.count() == 1
            link = @links.first()
        #in case our users create two events with the same topic, distinguish between them on the google scheduled events page based on their order
        else
            numPrevSameTopicEvents = Event.where(topic: event.topic).where('startTime >= :today_date_time', {today_date_time: DateTime.current.utc}).where('startTime < :new_event_date_time', {new_event_date_time: event.startTime.utc}).count
            j = 0
            @links.each do |l|
                if j == numPrevSameTopicEvents
                    link = l
                    break
                end
                j += 1
            end
        end
    
        #get the link we'll need to embed this google hangout in our site
        address = link[:href].split('=') #split, because it gives for example /watch?v=tuV0fqh5jgQ, but we will have to use it as https://www.youtube.com/watch?v=tuV0fqh5jgQ and we'll only store tuV0fqh5jgQ 
        viewLink = address[1]
        
        #get the link we'll need to give users to allow them to join this google hangout once it is live
        begin
            startBroadcastButton = @session.find(:xpath, '//*[@data-video-id="' + viewLink + '"]')
        rescue Exception => e
            showDebuggingErrorPage(e, @session)
            return
        end
        
        joinLinkPortion = startBroadcastButton[:"data-token"] #the identifier we'll need is in the data-token field on that element
        joinLink = 'https://plus.google.com/hangouts/_/ytl/' + joinLinkPortion + '?eid=112363874857852707319&hl=en_US&authuser=0'
    
        return [viewLink, joinLink]
    end
  
    #helper function which prepares for displaying an error page, it takes a screenshot, closes the driver, and creates an error message for debugging
    def showDebuggingErrorPage(exception, driver)
        exceptionImageFile = Rails.root.join('app', 'assets', 'images', 'error.png') #location to store the error screenshot, overwritten as each new error occurs
        driver.save_screenshot(exceptionImageFile) #take the screenshot
    
        #if the driver is selenium, need to quit it and also the headless Xvfb if on the server
        require 'selenium-webdriver'
        if driver.is_a?(Selenium::WebDriver::Driver)
            driver.quit
            if request.host_with_port != 'localhost:3000'
                @headless.destroy
            end
        end
        
        #go to the error page, where the error message includes the exception's message as well as the first line of the backtrace, for debugging
        redirect_to action: "error", :exceptionMessage => exception.message + " at " + exception.backtrace[0]
    end
 
end
