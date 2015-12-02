class User < ActiveRecord::Base
	has_many :posts
	has_many :events
	has_many :user_reports, class_name: "UserReport", foreign_key: "reporter_id", dependent: :destroy
	has_many :users_reporting, class_name: "UserReport", foreign_key: "reported_id", dependent: :destroy
	has_many :reporting_to, through: :user_reports, source: :reported
	has_many :reporters, through: :users_reporting, source: :reported
end
