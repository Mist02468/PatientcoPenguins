class PostController < ApplicationController
  def create
	if params[:type].present? && params[:text].present? && params[:tags].present?
      puts "Successful"
    else
    end
  end

  def comment
	if params[:text].present?
      puts "Successful"
    else
    end
  end

  def upvote
  end
end
