class DoctorAvailableSlotService
  def initialize(doctor, no_of_days = 8)
    @doctor = doctor
    @no_of_days = no_of_days
  end

  def all_available_slots
    time_slots = {}
    @gen_time_slots = general_day_time_slots
    @appointment_booked_array = upcoming_appointment_dates
    date = Date.today
    @no_of_days.times do
      key = date
      time_slots_for_day = []
      @gen_time_slots.each do |t|
        time_at_given_slot = parse_time(date, t)
        index_in_booked_appointment = @appointment_booked_array.index time_at_given_slot
        if index_in_booked_appointment
          @appointment_booked_array.delete_at index_in_booked_appointment
          next
        end
        time_slots_for_day << time_at_given_slot if (time_at_given_slot > Time.now)
      end
      time_slots[key] = time_slots_for_day unless time_slots_for_day.empty?
      date = date + 1.day
    end
    time_slots
  end

  def next_available_slot
    general_time_slots = general_day_time_slots
    appointment_booked_array = upcoming_appointment_dates
    next_available_slot = nil
    general_time_slots.each do |t|
      time_at_given_slot = parse_time t
      index_in_booked_appointment = appointment_booked_array.index time_at_given_slot
      if index_in_booked_appointment
        appointment_booked_array.delete_at index_in_booked_appointment
        next
      end
      if time_at_given_slot >= Time.now
        next_available_slot = time_at_given_slot
        break
      end
    end
    next_available_slot
  end

  private

  def general_day_time_slots
    start_time = @doctor.start_time.in_time_zone('Kolkata')
    end_time = @doctor.end_time.in_time_zone('Kolkata')
    break_start_time = Time.parse('2000-01-01 ' + @doctor.busy_slots[0].split[0] + " UTC")
    break_start_time = break_start_time.in_time_zone('Kolkata')
    break_end_time = break_start_time + @doctor.busy_slots[0].split[1].to_f.hour
    general_time_slots = []

    while break_start_time - start_time >= 3600 do
      general_time_slots.push start_time
      start_time = start_time + 1.hour
    end
    while end_time - break_end_time >= 3600 do
      general_time_slots.push break_end_time
      break_end_time = break_end_time + 1.hour
    end
    general_time_slots
  end

  def upcoming_appointment_dates
    sql_query = "SELECT start_timestamp FROM appointments WHERE start_timestamp >= current_timestamp and doctor_id = #{@doctor.id} ORDER BY start_timestamp;"
    appointment_booked = Appointment.find_by_sql(sql_query)
    appointment_booked_dates = []
    appointment_booked.each { |row| appointment_booked_dates << row[:start_timestamp].in_time_zone('Kolkata') }
    appointment_booked_dates
  end

  def parse_time(date = Date.today, t)
    Time.new(date.year, date.month, date.day, t.hour, t.min, 0, "+05:30")
  end
end