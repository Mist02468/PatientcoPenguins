class HomeFeedController < ApplicationController

  layout false
	
  def index
  end
  
  def subscribe
	if params[:tag].present?
      puts "Successful"
    else
    end
  end
end
