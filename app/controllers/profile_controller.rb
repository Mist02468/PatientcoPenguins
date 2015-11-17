class ProfileController < ApplicationController

	before_action :confirm_logged_in

  def report
		if params[:user_id].present?
			@user = User.find(params[:user_id])
      @user.reportedCount += 1
			@user.save!
			puts "reportCount " + @user.reportedCount.to_s
			@report = UserReport.new
			if params[:reporting_user_id].present?
				@report.reporter_id = params[:reporting_user_id]
			end
			if params[:reported_user_id].present?
				@report.reporter_id = params[:reporting_user_id]
			end
			if params[:reason].present?
				@report.message = params[:reason]
			end
			@report.save!
			puts @report.to_s
			redirect_to(controller: "profile", :action => "show", :user_id => params[:user_id])
		end
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
