class PostController < ApplicationController

	before_action :confirm_logged_in
  def index
    @posts = Post.find(:all)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.kind = 0
    @post.user = User.find(session[:user_id])
    if @post.save!
      redirect_to action: "show"
    else
      redirect_to action: 'new'
    end
  end

  def show
    puts "Post Saved in the DB!"
  end

  private
  def post_params
    params.require(:post).permit(:text)
  end
end
