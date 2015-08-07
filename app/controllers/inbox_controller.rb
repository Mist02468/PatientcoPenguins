class InboxController < ApplicationController
  def send
	if params[:messageId].present?
      puts "Successful"
    else
    end
  end

  def read
	if params[:messageId].present?
      puts "Successful"
    else
    end
  end
end
