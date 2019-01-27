json.extract! event, :id, :name, :description, :location, :member_price, :non_member_price, :start_datetime, :end_datetime, :user_id, :created_at, :updated_at
json.url event_url(event, format: :json)
