
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
	user = User.new do |u|
		u.firstName      = getValueFromLinkedInInfo(linkedInInfo, 'firstName')
		u.lastName       = getValueFromLinkedInInfo(linkedInInfo, 'lastName')
		u.location       = getValueFromLinkedInInfo(linkedInInfo, 'location')
		u.industry       = getValueFromLinkedInInfo(linkedInInfo, 'industry')
		u.numConnections = getValueFromLinkedInInfo(linkedInInfo, 'numConnections')
		u.position       = getValueFromLinkedInInfo(linkedInInfo, 'title')
		u.company        = getValueFromLinkedInInfo(linkedInInfo, 'company')
		u.reportedCount  = 0
		u.linkedInId     = getValueFromLinkedInInfo(linkedInInfo, 'id')
		u.emailAddress   = getValueFromLinkedInInfo(linkedInInfo, 'emailAddress')
	end
	user.save
	return user
  end

  def updateUser(linkedInInfo, user)
	user.update_attributes(:firstName      => getValueFromLinkedInInfo(linkedInInfo, 'firstName'),
	                       :lastName       => getValueFromLinkedInInfo(linkedInInfo, 'lastName'),
						   :location       => getValueFromLinkedInInfo(linkedInInfo, 'location'),
						   :industry       => getValueFromLinkedInInfo(linkedInInfo, 'industry'),
						   :numConnections => getValueFromLinkedInInfo(linkedInInfo, 'numConnections'),
						   :position       => getValueFromLinkedInInfo(linkedInInfo, 'title'),
						   :company        => getValueFromLinkedInInfo(linkedInInfo, 'company'),
						   :emailAddress   => getValueFromLinkedInInfo(linkedInInfo, 'emailAddress'))
	user.save
	return user
  end
  
  def getValueFromLinkedInInfo(linkedInInfo, key)
	if key == 'title' or key == 'company'
		if linkedInInfo.has_key? 'positions'
			if linkedInInfo['positions'].has_key? 'values'
				if key == 'title'
					if linkedInInfo['positions']['values'][0].has_key? 'title'
						return linkedInInfo['positions']['values'][0]['title']
					end
				elsif key == 'company'
					if linkedInInfo['positions']['values'][0].has_key? 'company'
						if linkedInInfo['positions']['values'][0]['company'].has_key? 'name'
							return linkedInInfo['positions']['values'][0]['company']['name']
						end
					end
				end
			end
		end
	elsif key == 'location'
		if linkedInInfo.has_key? 'location'
			if linkedInInfo['location'].has_key? 'name'
				return linkedInInfo['location']['name']
			end
		end
	else
		if linkedInInfo.has_key? key
			return linkedInInfo[key]
		end
	end
	return ''
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> 904ba26b8beb66ffc46c8dabe99d3ec9a9927144
