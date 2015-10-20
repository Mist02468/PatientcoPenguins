class HomeFeedController < ApplicationController

	before_action :confirm_logged_in

  layout false
	
  def index
    @posts = Post.all
  end

  def subscribe
	if params[:tag].present?
      puts "Successful"
    else
    end
  end
end
