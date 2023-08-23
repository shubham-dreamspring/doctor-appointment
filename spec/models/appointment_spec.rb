require 'rails_helper'

RSpec.describe Appointment, type: :model do
  fixtures(:users)
  fixtures(:doctors)

  context "attributes should be valid" do
    it "start_timestamp, end_timestamp, user_id, doctor_id, amount should be present" do
      appointment = Appointment.new({ user_id: users(:one) })

      expect(appointment.invalid?).to be_truthy
    end
    it "amount should be greater than 0" do
      appointment = Appointment.new({ start_timestamp: Date.new, end_timestamp: Date.new + 1.hour, user_id: users(:one), doctor_id: doctors(:one), amount: -1 })

      expect(appointment.invalid?).to be_truthy
    end

    it "doctor should be valid" do
      appointment = Appointment.new({ start_timestamp: Date.new, end_timestamp: Date.new + 1.hour, user_id: users(:one), doctor_id: doctors(:unavailable_doctor), amount: 50 })

      expect(appointment.invalid?).to be_truthy
    end
  end
end
