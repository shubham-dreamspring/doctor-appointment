class Doctor < ApplicationRecord
  has_many :appointments

  before_destroy :referenced_by_no_appointment

  validates :name, :fees, :image_url, presence: true
  validates :fees, numericality: { greater_than_or_equal_to: 0.01 }

  def get_next_available_slot
    start_time = self.start_time.in_time_zone('Kolkata')
    end_time = self.end_time.in_time_zone('Kolkata')
    break_start_time = Time.parse('2000-01-01 ' + self.busy_slots[0].split[0] + " UTC")
    break_start_time = break_start_time.in_time_zone('Kolkata')
    break_end_time = break_start_time + self.busy_slots[0].split[1].to_f.hour
    general_time_slots = []

    while break_start_time - start_time >= 3600 do
      general_time_slots.push start_time
      start_time = start_time + 1.hour
    end
    while end_time - break_end_time >= 3600 do
      general_time_slots.push break_end_time
      break_end_time = break_end_time + 1.hour
    end
    sql_query = "SELECT start_timestamp FROM appointments WHERE start_timestamp >= current_timestamp and doctor_id = #{self.id} ORDER BY start_timestamp;"
    appointment_booked = Appointment.find_by_sql(sql_query)
    appointment_booked_array = []
    appointment_booked.each { |row| appointment_booked_array << row[:start_timestamp].in_time_zone('Kolkata') }
    date = Date.today
    @next_available_slot = nil
    general_time_slots.each do |t|
      time_at_given_slot = Time.new(date.year, date.month, date.day, t.hour, t.min,0, "+05:30")
      index_in_booked_appointment = appointment_booked_array.index time_at_given_slot
      if index_in_booked_appointment
        appointment_booked_array.delete_at index_in_booked_appointment
        next
      end
      if time_at_given_slot >= Time.now
        @next_available_slot = time_at_given_slot
        break
      end
    end
    @next_available_slot
  end

  private

  def referenced_by_no_appointment
    unless appointments.empty?
      errors.add(:base, 'Appointments is present')
      throw :abort
    end
  end

end
