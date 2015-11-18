class ProfileController < ApplicationController

	before_action :confirm_logged_in

  def report
		if params[:reported_user_id].present?
			@user = User.find(params[:reported_user_id])
      @user.reportedCount += 1
			puts "reportCount " + @user.reportedCount.to_s
			@report = UserReport.new
			if params[:reporting_user_id].present?
				@user2 = User.find(params[:reporting_user_id])
				@report.reporter_id = params[:reporting_user_id]
			end
			if params[:reported_user_id].present?
				@report.reported_id = params[:reported_user_id]
			end
			if params[:reason].present?
				@report.message = params[:reason]
			end
			@report.save
			@user.user_reports << @report
			@user2.users_reporting << @report
			@user.save!
			@user2.save!
			puts @report.to_s
			redirect_to(controller: "profile", :action => "show", :user_id => params[:reported_user_id])
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
						@reportable = UserReport.where("reporter_id != #{session[:user_id]}").count == 0
						puts "reportable is: " + @reportable.to_s
		end
  end
end
