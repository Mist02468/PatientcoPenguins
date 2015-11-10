class PostController < ApplicationController

	before_action :confirm_logged_in
  def index
    @posts = Post.find(:all)
  end

  def new
    @post = Post.new
    @tagsToAdd = []
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
  
  def addTag
    @post = Post.new
    @post.text = params[:currentPostText]
	@tagsToAdd = params[:tagsToAdd].split(" ")
    if (@tagsToAdd.include? tag_params['name']) == false
        @tagsToAdd << tag_params['name']
    end
	render "new"
  end
  
  def removeTag
    @post = Post.new
    @post.text = params[:currentPostText]
	@tagsToAdd = params[:tagsToAdd]
    @tagsToAdd.delete(params[:tag])
	render "new" #can redirect instead?
  end

  private
  def post_params
    params.require(:post).permit(:text)
  end
  def tag_params
	params.require(:tag).permit(:name)
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
