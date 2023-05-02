json.extract! doctor, :id, :name, :address, :image_url, :fees, :busy_slots, :start_time, :end_time, :created_at, :updated_at
json.url doctor_url(doctor, format: :json)
