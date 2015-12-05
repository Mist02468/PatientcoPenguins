# Tag model
class Tag < ActiveRecord::Base
	# validation
	validates :name, uniqueness: true, presence: true
	# tags belong to many posts
	has_and_belongs_to_many :posts
end
