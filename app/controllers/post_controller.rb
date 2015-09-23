class PostController < ApplicationController

	before_action :confirm_logged_in

  def new
    @post = Post.new
  end

  def create
      @post = Post.new(post_params)
      if @post.save
        puts "Successful"
      else
      # puts "Failure"
      end
  end

  def comment
	if params[:text].present?
      puts "Successful"
    else
    end
  end
  def post_params
    params.permit(:type,:tags,:text)
  end
  def upvote
  end
end
