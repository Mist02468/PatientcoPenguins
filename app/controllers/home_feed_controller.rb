class HomeFeedController < ApplicationController

  before_action :confirm_logged_in
    
  def show
    if params[:tag_id].present?
        @tag   = Tag.find(params[:tag_id])
        @posts = Post.joins(:tags).where(tags: { id: params[:tag_id] })
    else
        @tag   = nil
        @posts = Post.all
    end
  end
  
end