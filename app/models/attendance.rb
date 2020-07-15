class Attendance < ApplicationRecord
  include Workflow
    workflow_column :state
  belongs_to :event
  belongs_to :user

  workflow do
    state :request_sent do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
      state :accepted
      state :rejected
  end

  def self.join_event(user_id, event_id, state)
    self.create(user_id: user_id, event_id: event_id, state: state)
  end

  scope :pending, -> {where(state: 'request_sent')}
  scope :accepted, -> {where(state: 'accepted')}
  scope :rejected, -> {where(state: 'rejected')}
end
