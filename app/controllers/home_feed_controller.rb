#controller for the home feed page: show
class HomeFeedController < ApplicationController

    #make sure the user is logged in before showing them the home feed
    before_action :confirm_logged_in
    
    #pulls all the posts and events from our db, perhaps filtered by a tag, to be displayed by the view
    def show
        #if a tag id parameter is present, only pull the posts and events with that tag
        if params[:tag_id].present?
            @tag   = Tag.find(params[:tag_id])
            @posts = Post.joins(:tags).where(tags: { id: params[:tag_id] })
            @events = Event.joins(:tags).where(tags: { id: params[:tag_id] })
        else
            @tag   = nil
            @posts = Post.all
            @events = Event.all
        end
    end
  
end