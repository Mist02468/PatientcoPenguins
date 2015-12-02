class PostController < ApplicationController

  before_action :confirm_logged_in

  def new
    @post = Post.new
    if params[:tag].present?
        @post.text = params[:currentPostText]
        addTag()
    elsif params[:tagToRemove].present?
        @post.text = params[:currentPostText]
        removeTag()
    else
        @tagsToAdd = []
    end
  end

  def create
    @post = Post.new(post_params)
    isComment = false
    if params[:kind].present?
      @post.kind = params[:kind].to_i
      @post.originatingPost_id = params[:originatingPost_id].to_i
      isComment = true
    else
      @post.kind = 0
      @tagsToAdd = params[:tagsToAdd].split(" ")
	  @tagsToAdd.each do |t|
		@post.tags << createTag(t)
	  end
  	end
    @post.user = User.find(session[:user_id])
    if @post.save!
      if isComment
        redirect_to action: "show", :id => params[:originatingPost_id]
      else
        redirect_to action: "show", :id => @post.id
      end
    else
      redirect_to action: 'new'
    end
  end

  def show
    puts "Post Saved in the DB!"
    @post = Post.find(params[:id])
    @comments = Post.where(:originatingPost_id => params[:id])
  end

  private
  def post_params
    params.require(:post).permit(:text)
  end
  def tag_params
	params.require(:tag).permit(:name)
  end
end
