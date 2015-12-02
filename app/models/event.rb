class Event < ActiveRecord::Base
    validates :topic, presence: true
	belongs_to :host, class_name: "User"
	has_and_belongs_to_many :tags
end
