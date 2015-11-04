class ProfileController < ApplicationController

	before_action :confirm_logged_in

  def report
  end

  def message
  end

  def subscribe
  end

  def show
		if params[:user_id].present?
			@user = User.find(params[:user_id])
            @posts = Post.where("user_id = #{@user.id}").where("kind = 0").order("voteCount DESC").order("created_at DESC")
		end
  end
end
