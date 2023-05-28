require 'rails_helper'

RSpec.describe Appointment, type: :model do
  context "attributes should be valid" do
    it "start_timestamp, end_timestamp, user_id, doctor_id, amount can't be empty" do
      doctor = Appointment.new({ user_id: 1 })
      expect(doctor.invalid?).to be_truthy
    end
    it "amount should be greater than 0" do
      doctor = Appointment.new({ start_timestamp: Date.new, end_timestamp: Date.new + 1.hour, user_id: 1, doctor_id: 2, amount: -1 })
      expect(doctor.invalid?).to be_truthy
    end
  end
end
