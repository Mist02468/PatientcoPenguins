class HomeFeedController < ApplicationController

	before_action :confirm_logged_in

  layout false
	
  def index
  end

  def search
    Post.search do
      fulltext params[:kind]
    end
  end
  
  def subscribe
	if params[:tag].present?
      puts "Successful"
    else
    end
  end
end
