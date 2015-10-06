class Event < ActiveRecord::Base
	has_and_belongs_to_many :users
	belongs_to :host, class_name: "User"
end
