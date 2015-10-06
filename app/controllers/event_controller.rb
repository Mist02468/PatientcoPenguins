class EventController < ApplicationController

	before_action :confirm_logged_in
	
  def new
    @event = Event.new
  end
  
  def create
	@event = Event.new(event_params)
	@event.startTime = DateTime.civil(params[:datetime][:year].to_i, params[:datetime][:month].to_i, params[:datetime][:day].to_i, params[:datetime][:hour].to_i, params[:datetime][:minute].to_i)
	@event.host = User.find(session[:user_id])
	if @event.save!
      redirect_to action: "show", :id => @event.id
    else
      redirect_to action: 'new'
    end
  end
  
  def show
    puts "Event Saved in the DB!"
    @event = Event.find(params[:id])
  end

  def join
  end

  def invite
	if params[:userId].present?
      puts "Successful"
    else
    end
  end
  
  def createGoogleDoc
	render nothing: true
	require 'google/api_client'
	
	serviceAccount_email = '54678097976-94j19m7hap7c8k0jkii8gol8bg2hltco@developer.gserviceaccount.com'
	serviceAccount_PKCS12_filePath = Rails.root.join('config', 'Capstone Project-1c7361b30ae2.p12')
	
	key = Google::APIClient::PKCS12.load_key(serviceAccount_PKCS12_filePath, 'notasecret')
    asserter = Google::APIClient::JWTAsserter.new(serviceAccount_email, 'https://www.googleapis.com/auth/drive', key)
    client = Google::APIClient.new()
    client.authorization = asserter.authorize()
    
    service = client.discovered_api('drive', 'v2')
    file = service.files.insert.request_schema.new({
		   'title' => 'Test',
		   'mimeType' => 'application/vnd.google-apps.document'})
	file.parents = [{'id' => '0B2PZURw_M0AlfkhISFdZQXgxd0RnTzVERmJxZ19ndDZVQV81T0tZTVpoWGtQYV9oYkdEYjA'}]
    
    result = client.execute(
             :api_method => service.files.insert,
             :body_object => file)
             
    if result.status == 200
		puts 'Successful'
		pp result
		#pp JSON.parse(client.execute(:api_method => service.files.list).env['body'])
		#pp client.execute(:api_method => service.files.list)
    else
		puts 'Unsuccessful'
	end
  end
  
  def createGoogleHangoutOnAir
  end
  
  private
  def event_params
    params.require(:event).permit(:topic)
  end
end
