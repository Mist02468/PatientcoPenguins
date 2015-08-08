class Post < ActiveRecord::Base
	enum type: [ :share, :question, :discussion, :comment ]
	belongs_to :user
	has_and_belongs_to_many :tags
	has_many :comments, class_name: "Post", foreign_key: "originatingPost_id"
	belongs_to :originatingPost, class_name: "Post"
end
