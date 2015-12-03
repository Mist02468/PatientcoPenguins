#controller for the profile page: show
class ProfileController < ApplicationController

    #make sure the user is logged in before showing them a profile or allowing them to report a user
    before_action :confirm_logged_in
  
    #finds the user whose id is passed as the parameter and that user's posts, to be displayed by the view
    def show
		if params[:user_id].present?
            @user = User.find(params[:user_id])
            #only posts, not comments which have kind=2, created by this user
            @posts = Post.where("user_id = #{@user.id}").where("kind = 0").order("created_at DESC")
            #whether this is the profile of the logged in user
			@is_user = @user.id == session[:user_id]
            #whether the logged in user has not already reported this user
			@reportable = UserReport.where("reported_id == #{@user.id}").where("reporter_id == #{session[:user_id]}").count == 0
		end
    end

    #reports the user whose profile is being viewed
    def report
		if params[:reported_user_id].present?
			@user = User.find(params[:reported_user_id]) #user who is being reported, whose profile is being viewed
            #report them by increasing their reportedCount tally and creating a report
            @user.reportedCount += 1
            #a report logs the reporter, the user who is being reported, and the reason the reporter says that they are reporting this user
			@report = UserReport.new
			if params[:reporting_user_id].present?
				@user2 = User.find(params[:reporting_user_id]) #the user who is reporting
				@report.reporter_id = params[:reporting_user_id]
			end
			if params[:reported_user_id].present?
				@report.reported_id = params[:reported_user_id]
			end
			if params[:reason].present?
				@report.message = params[:reason]
			end
			@report.save #create that report
            
            #update the users as well, to reflect this new report
			@user.users_reporting << @report
			@user2.user_reports << @report
			@user.save!
			@user2.save!

            #stay on this user's profile page
			redirect_to(controller: "profile", :action => "show", :user_id => params[:reported_user_id])
		end
    end

end
