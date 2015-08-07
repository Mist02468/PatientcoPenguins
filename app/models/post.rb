class Post < ActiveRecord::Base
	enum type: [ :share, :question, :discussion, :comment ]
end
