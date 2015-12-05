# User Report model
class UserReport < ActiveRecord::Base
  belongs_to :reporter, class_name: "User"
  belongs_to :reported, class_name: "User"
end
