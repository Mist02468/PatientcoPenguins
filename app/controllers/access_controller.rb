#controller for the access pages: login, logout, and locked
class AccessController < ApplicationController

    #user does not need to be logged in, because when accessing these pages they will be in the process of doing so
    before_action :confirm_logged_in, :except => [:login, :startLinkedInAuth, :finishLinkedInAuth, :logout, :locked]

    #simply displays a static login page, with a LinkedIn button which calls the startLinkedInAuth method
    def login
    end

    #simply displays a static page, with a message explaining that the user is locked out
    def locked
    end

    #user is logged out by removing their id from the session, so then they are redirected to the login page
    def logout
        session[:user_id] = nil
        redirect_to(:action => "login")
    end

    #first part of the login process, redirects to LinkedIn for user authentication
    def startLinkedInAuth
        require 'oauth2'

        client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :authorize_url => '/uas/oauth2/authorization')
        #specifies our site url which LinkedIn should redirect back to after the user successfully logs in
        #also includes a random state for security and the LinkedIn data which we will request from the user (basic profile info and their email address)
        redirect_to client.auth_code.authorize_url(:redirect_uri => request.protocol + request.host_with_port + '/access/finishLinkedInAuth') + '&state=' + getRandomState + '&scope=r_basicprofile%20r_emailaddress'
    end

    #final part of the login process, gets data from LinkedIn to create a new user or update an existing one
    def finishLinkedInAuth
        require 'oauth2'

        if params[:code].present? && params[:state].present?
            client = OAuth2::Client.new('75yetg1f8atx89', 'le39CGDc1yQLCo9U', :site => 'https://www.linkedin.com/', :token_url => '/uas/oauth2/accessToken')
            token = client.auth_code.get_token(params[:code], :redirect_uri => request.protocol + request.host_with_port + '/access/finishLinkedInAuth')

            #use the token to get this user's first-name, last-name, location, industry, num-connections, positions, email-address, and id
            response = token.get('https://api.linkedin.com/v1/people/~:(first-name,last-name,location,industry,num-connections,positions,email-address,id)?format=json', :headers => { 'authorization' => 'Bearer ' + token.token })
            response = ActiveSupport::JSON.decode(response.response.env['body']) #convert that JSON to a ruby array

            #search our database to see whether this is a new user
            found_user = User.where(:linkedInId => response['id']).first
            if found_user == nil
                found_user = createNewUser(response)
            else
                found_user = updateUser(response, found_user)
            end
      
            #set their id in the session, which designates them as logged in
            session[:user_id] = found_user.id
      
            #check whether they should be allowed into our site, as long as they have not been reported three or more times
            if found_user.reportedCount >= 3
                #if they have been reported too many times, log them out and redirect them to the locked page
                session[:user_id] = nil
                redirect_to(:action => 'locked')
            else
                redirect_to(:controller => 'home_feed', :action => 'show') #otherwise, redirect them to the home feed
            end
      
        elsif params[:error].present? && params[:error_description].present?
            puts "Rejected"
      
        else
            puts "Unexpected response"
        end
    end

    private

    #helper function which returns a 21 digit, random, numeric state string 
    def getRandomState
        prng = Random.new()
    
        #picks 21 random digits, becomes the state, a 21 digit number
        randStringOfNums = ''
        for i in 0..20
            randStringOfNums += prng.rand(0..9).to_s
        end
    
        return randStringOfNums
    end

    #helper function which creates a new user in our db where its attributes are filled with the data from LinkedIn
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

    #helper function which updates the attributes of a user already in our db with the data from LinkedIn, in case they have changed it recently
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

    #helper function which can traverse the array of LinkedIn data, returning a specific piece of information or an empty string if LinkedIn did not include it in their response for this user
    def getValueFromLinkedInInfo(linkedInInfo, key)
        if key == 'title' or key == 'company'
            if linkedInInfo.has_key? 'positions'
                #take the title and company from their most recent postion, the 0th index, if they have one
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
            #LinkedIn doesn't include parts of the array if the user doesn't have that part of their profile filled out, 
            #so that's why you have to check if a key exists first, before trying to access its value
            if linkedInInfo.has_key? key
                return linkedInInfo[key]
            end
        end
    
        return ''
    end
  
end
