class DoctorAvailableSlotService
  def initialize(doctor, no_of_days = 8)
    @doctor = doctor
    @no_of_days = no_of_days
  end

  def all_available_slots
    time_slots = {}
    date = Date.today
    @no_of_days.times do
      time_slots_for_day = available_slots_on_a_date_in_future(date)
      time_slots[date] = time_slots_for_day unless time_slots_for_day.empty?
      date = date + 1.day
    end
    time_slots
  end

  def next_available_slot
    next_available_slot = available_slots_on_a_date_in_future(Date.today)
    next_available_slot.empty? ? nil : next_available_slot.first
  end

  private

  def general_day_time_slots
    start_time = @doctor.start_time.in_time_zone('Kolkata')
    end_time = @doctor.end_time.in_time_zone('Kolkata')
    break_start_time = Time.parse('2000-01-01 ' + @doctor.busy_slots[0].split[0] + " UTC")
    break_start_time = break_start_time.in_time_zone('Kolkata')
    break_end_time = break_start_time + @doctor.busy_slots[0].split[1].to_f.hour
    general_time_slots = []

    while break_start_time - start_time >= 1.hour.in_seconds do
      general_time_slots.push start_time
      start_time = start_time + 1.hour
    end
    while end_time - break_end_time >= 1.hour.in_seconds do
      general_time_slots.push break_end_time
      break_end_time = break_end_time + 1.hour
    end
    general_time_slots
  end

  def upcoming_appointment_dates
    appointment_booked = Appointment.where("start_timestamp >= :current_timestamp and doctor_id = :doc_id", doc_id: @doctor.id, current_timestamp: Time.now.in_time_zone('UTC')).order(:start_timestamp)
    appointment_booked_dates = []
    appointment_booked.each { |row| appointment_booked_dates << row[:start_timestamp].in_time_zone('Kolkata') }
    appointment_booked_dates
  end

  def available_slots_on_a_date_in_future(date)
    gen_time_slots = general_day_time_slots
    appointment_booked_array = upcoming_appointment_dates
    time_slots_for_day = []
    gen_time_slots.each do |time_slot|
      time_at_given_slot = parse_time(date, time_slot)
      index_in_booked_appointment = appointment_booked_array.index time_at_given_slot
      if index_in_booked_appointment
        appointment_booked_array.delete_at index_in_booked_appointment
        next
      end
      time_slots_for_day << time_at_given_slot if (time_at_given_slot > Time.now)
    end
    time_slots_for_day
  end

  def parse_time(date = Date.today, time_slot)
    Time.new(date.year, date.month, date.day, time_slot.hour, time_slot.min, 0, "+05:30")
  end
end