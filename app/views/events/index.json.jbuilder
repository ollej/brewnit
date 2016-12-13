json.array!(@events) do |event|
  json.extract! event, :id, :name, :created_at, :updated_at, :description,
    :location, :organizer, :event_type, :held_at, :url
end

