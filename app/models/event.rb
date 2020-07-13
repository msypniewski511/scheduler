class Event < ApplicationRecord
  belongs_to :organizers, class_name: "user", foreign_key: "id", optional: true
  has_many :attendances
  has_many :events, :through => :attendances

  def self.event_owner(organizer_id)
    User.find_by id: organizer_id
  end
end
