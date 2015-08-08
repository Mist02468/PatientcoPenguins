class Post < ActiveRecord::Base
	enum type: [ :share, :question, :discussion, :comment ]
	belongs_to :user
end
