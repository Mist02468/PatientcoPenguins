# model for posts
class Post < ActiveRecord::Base
	# validation
    validates :text, presence: true
    # kind of posts are enumerated
    enum kind: [ :share, :question, :comment ]
	# each post is owned by a user
    belongs_to :user
	# each event has and can be referenced by tags
    has_and_belongs_to_many :tags
    # each post can have many comments with foreign key as originatingPost_id
    has_many :comments, class_name: "Post", foreign_key: "originatingPost_id"
    # assigning to post class
    belongs_to :originatingPost, class_name: "Post"
end
