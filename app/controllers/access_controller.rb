
class AccessController < ApplicationController

	before_action :confirm_logged_in, :except => [:login, :startLinkedInAuth, :finishLinkedInAuth, :logout]
	
  def login
	#login form
  end

  def startLinkedInAuth
    require 'oauth2'

    client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :authorize_url => '/uas/oauth2/authorization')

	redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth') + '&state=' + getRandomState #might want to apply for '&scope=r_fullprofile' and more
  end

  def finishLinkedInAuth
    require 'oauth2'

    if params[:code].present? && params[:state].present?
      puts "Successful"

      client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :token_url => '/uas/oauth2/accessToken')
      token = client.auth_code.get_token(params[:code], :redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth')

      response = token.get('https://api.linkedin.com/v1/people/~?format=json', :headers => { 'authorization' => 'Bearer ' + token.token })
      response = ActiveSupport::JSON.decode(response.response.env['body'])
      
      found_user = User.where(:linkedInId => response['id']).first
      pp found_user
      if found_user == nil
		found_user = createNewUser(response)
	  end
	  session[:user_id] = found_user.id
      
      redirect_to(:controller => 'post', :action => 'create')
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
		u.location       = nil
		u.industry       = nil
		u.numConnections = nil
		u.position       = linkedInInfo['headline']
		u.company        = nil
		u.reportedCount  = 0
		u.linkedInId     = linkedInInfo['id']
	end
	user.save
	return user
  end
	
end
