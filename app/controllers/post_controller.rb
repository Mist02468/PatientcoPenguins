#controller for the post pages: new, create, and show
class PostController < ApplicationController

    #make sure the user is logged in before showing them a post or allowing them to create one
    before_action :confirm_logged_in

    #initializes a new post object, keeping track of the text and tags which the user has typed into the page thus far
    def new
        @post = Post.new
        #if new is being called because the user clicked the add tag button
        if params[:tag].present?
            @post.text = params[:currentPostText]
            addTag()
        #if new is being called because the user clicked an x to remove one of the tags
        elsif params[:tagToRemove].present?
            @post.text = params[:currentPostText]
            removeTag()
        #if new is being called because the user has just navigated to this page
        else
            @tagsToAdd = []
        end
    end

    #creates a post in our db after the user submits the form by clicking the post button on the new page or the comment button on a show page
    def create
        #initialize a new post object with the parameters submitted, validated by post_params
        @post = Post.new(post_params)
        
        isComment = false
        #check whether this is actually a comment, meaning it should have kind=2 and will need an originating post id
        if params[:kind].present?
            @post.kind = params[:kind].to_i
            @post.originatingPost_id = params[:originatingPost_id].to_i
            isComment = true
            
        #otherwise, it is a post, which optionally has tags
        else
            @post.kind = 0
            @tagsToAdd = params[:tagsToAdd].split(" ")
            @tagsToAdd.each do |t|
                @post.tags << createTag(t)
            end
        end
        
        #either way, the currently logged in user should be logged as the creator of this post/comment
        @post.user = User.find(session[:user_id])
        
        if @post.save!
            if isComment
                redirect_to action: "show", :id => params[:originatingPost_id] #stay on the post's show page
            else
                redirect_to action: "show", :id => @post.id #go to this new post's show page
            end
        else
            redirect_to action: 'new' #upon failure, try again
        end
    end

    #pulls the post and any comments (which are themselves posts) on that post from our db for the view to display
    def show
        @post = Post.find(params[:id])
        @comments = Post.where(:originatingPost_id => params[:id])
    end

    private
    
    def post_params
        params.require(:post).permit(:text) #page is allowed to set the text field of a new post
    end
    
    def tag_params
        params.require(:tag).permit(:name) #page is allowed to set the name field of a new tag
    end
    
end
