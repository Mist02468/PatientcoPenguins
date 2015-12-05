# event model
class Event < ActiveRecord::Base
    # validation
    validates :topic, presence: true
    # each event belongs to host
    belongs_to :host, class_name: "User"
    # each event has and can be referenced by tags
    has_and_belongs_to_many :tags
end
