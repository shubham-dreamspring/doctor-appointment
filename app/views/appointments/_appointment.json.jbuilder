json.extract! appointment, :id, :doctor_id, :user_id, :start_timestamp, :end_timestamp, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
