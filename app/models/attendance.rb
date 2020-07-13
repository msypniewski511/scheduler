class Attendance < ApplicationRecord
  attr_accessor :state
  belongs_to :event
  belongs_to :user

  def self.join_event(user_id, event_id,state)
    self.create(user_id: user_id, event_id: event_id,
    state: state)
    end
end
