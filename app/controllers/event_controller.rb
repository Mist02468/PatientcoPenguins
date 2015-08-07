class EventController < ApplicationController
  def create
	if params[:time].present? && params[:topic].present?
      puts "Successful"
    else
    end
  end

  def join
  end

  def invite
	if params[:userId].present?
      puts "Successful"
    else
    end
  end
  
  def createGoogleDoc
  end
  
  def createGoogleHangoutOnAir
  end
end
