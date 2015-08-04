
class AccessController < ApplicationController
  def login
  end

  def logout
  end

  def startLinkedInAuth
    require 'oauth2'

    client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/uas/oauth2/authorization')

	redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth')
  end

  def finishLinkedInAuth
    render nothing: true
    require 'oauth2'

    if params[:code].present? && params[:state].present?
      puts "Successful"

      client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/uas/oauth2/accessToken')
      token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:3000/access/finishLinkedInAuth', :headers => {'Authorization' => 'Basic some_password'})

      #response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
      #response.class.name
    elsif params[:error].present? && params[:error_description].present?
      puts "Rejected"
    else
      puts "Unexpected response"
    end
  end
end
