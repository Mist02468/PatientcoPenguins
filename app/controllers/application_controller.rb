class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private

  def confirm_logged_in
    unless session[:user_id]
      redirect_to(:controller => 'access', :action => 'login')
      return false #halts the before_action
    else
      return true
    end
  end
  
  def get_secret(nameOfSecret)
    secretsFile = Rails.root.join('config', 'accountSecrets.yml')
    secrets = YAML.load_file(secretsFile)
    return secrets[nameOfSecret]
  end
  
  def addTag
	@tagsToAdd = params[:tagsToAdd].split(" ")
    if (@tagsToAdd.include? tag_params['name']) == false
        @tagsToAdd << tag_params['name']
    end
  end
  
  def removeTag
	@tagsToAdd = params[:tagsToAdd].split(" ")
    @tagsToAdd.delete(params[:tagToRemove])
  end
  
  def createTag(tagName)
	found_tag = Tag.where(:name => tagName).first
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
