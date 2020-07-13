json.extract! event, :id, :title, :start_time, :end_time, :location, :agenda, :address, :organizer_id, :created_at, :updated_at
json.url event_url(event, format: :json)
