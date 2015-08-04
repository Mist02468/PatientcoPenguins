
class AccessController < ApplicationController
  def login
  end

  def logout
  end

  def startLinkedInAuth
    require 'oauth2'

    client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :authorize_url => '/uas/oauth2/authorization')

	redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth') + '&state=' + getRandomState #might want to apply for '&scope=r_fullprofile' and more
  end

  def finishLinkedInAuth
    render nothing: true
    require 'oauth2'

    if params[:code].present? && params[:state].present?
      puts "Successful"

      client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :token_url => '/uas/oauth2/accessToken')
      token = client.auth_code.get_token(params[:code], :redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth')

      response = token.get('https://api.linkedin.com/v1/people/~?format=json', :headers => { 'authorization' => 'Bearer ' + token.token })
      pp response.response.env['body']
    elsif params[:error].present? && params[:error_description].present?
      puts "Rejected"
    else
      puts "Unexpected response"
    end
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
  
end
