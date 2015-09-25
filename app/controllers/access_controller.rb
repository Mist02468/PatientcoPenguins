
class AccessController < ApplicationController

	before_action :confirm_logged_in, :except => [:login, :startLinkedInAuth, :finishLinkedInAuth, :logout]
	
  def login
	#login form
  end

  def startLinkedInAuth
    require 'oauth2'

    client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :authorize_url => '/uas/oauth2/authorization')

	redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth') + '&state=' + getRandomState + '&scope=r_basicprofile%20r_emailaddress'
  end

  def finishLinkedInAuth
    require 'oauth2'

    if params[:code].present? && params[:state].present?
      puts "Successful"

      client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :token_url => '/uas/oauth2/accessToken')
      token = client.auth_code.get_token(params[:code], :redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth')

      response = token.get('https://api.linkedin.com/v1/people/~:(first-name,last-name,location,industry,num-connections,positions,email-address,id)?format=json', :headers => { 'authorization' => 'Bearer ' + token.token })
      response = ActiveSupport::JSON.decode(response.response.env['body'])
      #pp response
      
      found_user = User.where(:linkedInId => response['id']).first
      if found_user == nil
		found_user = createNewUser(response)
	  else
		found_user = updateUser(response, found_user)
	  end
	  session[:user_id] = found_user.id
      
      redirect_to(:controller => 'post', :action => 'new')
    elsif params[:error].present? && params[:error_description].present?
      puts "Rejected"
    else
      puts "Unexpected response"
    end
  end
  
  def logout
	session[:user_id] = nil
    redirect_to(:action => "login")
  end
  
  private 
  
  def getRandomState
	prng = Random.new()
	
	randStringOfNums = ''
	for i in 0..20
		randStringOfNums += prng.rand(0..9).to_s
	end
	return randStringOfNums
  end
  
  def createNewUser(linkedInInfo)
	print "Make sure here"
	user = User.new do |u|
		u.firstName      = linkedInInfo['firstName']
		u.lastName       = linkedInInfo['lastName']
		u.location       = linkedInInfo['location']['name']
		u.industry       = linkedInInfo['industry']
		u.numConnections = linkedInInfo['numConnections']
		u.position       = linkedInInfo['positions']['values'][0]['title']
		u.company        = linkedInInfo['positions']['values'][0]['company']['name']
		u.reportedCount  = 0
		u.linkedInId     = linkedInInfo['id']
		u.emailAddress   = linkedInInfo['emailAddress']
	end
	user.save
	return user
  end
  
  def updateUser(linkedInInfo, user)
	user.update_attributes(:firstName      => linkedInInfo['firstName'],
	                       :lastName       => linkedInInfo['lastName'],
						   :location       => linkedInInfo['location']['name'],
						   :industry       => linkedInInfo['industry'],
						   :numConnections => linkedInInfo['numConnections'],
						   :position       => linkedInInfo['positions']['values'][0]['title'],
						   :company        => linkedInInfo['positions']['values'][0]['company']['name'],
						   :emailAddress   => linkedInInfo['emailAddress'])
	user.save
	return user
  end
end
