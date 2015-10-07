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
		end
  end
end
