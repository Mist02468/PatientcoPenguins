#parent controller which has common helper functions related to authentication, credentials, and tagging
class ApplicationController < ActionController::Base

    #prevents CSRF attacks by raising an exception
    protect_from_forgery with: :exception
  
    private

    #helper function which confirms a user is logged in by checking the session, otherwise they are redirected to the login page
    def confirm_logged_in
        #ruby unless means execute this code if the condition is false, if the user_id is NOT set in the session
        unless session[:user_id]
            redirect_to(:controller => 'access', :action => 'login')
            return false #halts the before_action
        else #if the user_id is set in the session
            return true
        end
    end
  
    #helper function which loads a credential from our account secrets YAML file which is not committed to Github
    def get_secret(nameOfSecret)
        secretsFile = Rails.root.join('config', 'accountSecrets.yml')
        secrets = YAML.load_file(secretsFile)
        return secrets[nameOfSecret]
    end
  
    #helper function which adds a tag to the list of tags which will be added to the post or event when it is created
    def addTag
        #they are stored as a string parameter, where tags are separated by spaces, so split to create an array
        @tagsToAdd = params[:tagsToAdd].split(" ")
        #as long as the tag to add is not already in the array, add it
        if (@tagsToAdd.include? tag_params['name']) == false
            @tagsToAdd << tag_params['name']
        end
    end
  
    #helper function which removes a tag from the list of tags which will be added to the post or event when it is created
    def removeTag
        #they are stored as a string parameter, where tags are separated by spaces, so split to create an array
        @tagsToAdd = params[:tagsToAdd].split(" ")
        #remove this tag from the list
        @tagsToAdd.delete(params[:tagToRemove])
    end
  
    #helper function which 'creates' a tag, by finding that it is already in our db and returning it or actually creating and saving a new object
    def createTag(tagName)
        found_tag = Tag.where(:name => tagName).first
        #we only store unique tags, so only create a new tag if it was not found
        if found_tag == nil
            tag = Tag.new()
            tag.name = tagName
            tag.save
        else
            tag = found_tag
        end
        return tag
    end
  
end
