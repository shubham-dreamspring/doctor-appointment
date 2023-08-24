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

    context "when doctor already has an appointment at that time" do
      let(:freeze_time) { Time.utc(2023, 2, 1, 6, 29) }

      it "should be valid" do

        Appointment.create!(doctor_id: doctors(:three).id,
                            user_id: users(:one).id,
                            start_timestamp: freeze_time,
                            end_timestamp: freeze_time + 1.hour,
                            amount: doctors(:three).fees)

        appointment = Appointment.new(doctor_id: doctors(:three).id,
                                      user_id: users(:two).id,
                                      start_timestamp: freeze_time,
                                      end_timestamp: freeze_time + 1.hour,
                                      amount: doctors(:three).fees)

        expect(appointment.invalid?).to be_truthy
      end
    end

    context "when user already has an appointment at that time" do
      let(:freeze_time) { Time.utc(2023, 3, 1, 6, 29) }

      it "should be valid" do
        doc = Doctor.create!(name: 'Dr. test6',
                             address: 'Stanford University',
                             image_url: 'doctor1_image.png',
                             fees: 12)
        Appointment.create!(doctor_id: doc.id,
                            user_id: users(:one).id,
                            start_timestamp: freeze_time,
                            end_timestamp: freeze_time + 1.hour,
                            amount: doc.fees)

        appointment = Appointment.new(doctor_id: doctors(:three).id,
                                      user_id: users(:one).id,
                                      start_timestamp: freeze_time,
                                      end_timestamp: freeze_time + 1.hour,
                                      amount: doc.fees)

        expect(appointment.invalid?).to be_truthy
      end
    end
  end
end