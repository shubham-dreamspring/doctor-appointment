require_relative '../../app/services/doctor_available_slot_service'
require "rails_helper"
require 'timecop'

RSpec.describe DoctorAvailableSlotService do
  fixtures(:doctors)
  fixtures(:appointments)

  let(:freeze_time) { Time.utc(2023, 2, 1, 6, 29) }

  around do |example|
    Timecop.freeze(freeze_time) do
      example.run
    end
  end

  describe "#all_available_slots", type: :helper do
    context 'doctor has no appointment' do
      it "should return all available slots" do
        no_of_days = 8
        doctor = doctors(:two)

        available_slots = DoctorAvailableSlotService.new(doctor, no_of_days).all_available_slots
        first_day_with_available_slots = available_slots.keys.first
        first_slot_available = available_slots[first_day_with_available_slots].first

        expect(available_slots.size).to eql no_of_days
        expect(first_day_with_available_slots).to eql Date.new(freeze_time.year, freeze_time.month, freeze_time.day)
        expect(first_slot_available).to be > freeze_time
      end
    end

    context "if doctor has appointments" do
      it "should exclude all the appointments" do
        doctor = doctors(:one)
        appointment = doctor.appointments.create!({
                                                    doctor_id: 1,
                                                    user_id: 2,
                                                    start_timestamp: '2023-02-01 06:30:00 UTC',
                                                    end_timestamp: '2023-02-01 07:30:00 UTC',
                                                    currency: 'INR',
                                                    amount: 50,
                                                  })

        available_slots = DoctorAvailableSlotService.new(doctor).all_available_slots
        first_day_with_available_slots = available_slots.keys.first

        expect(first_day_with_available_slots).to eql Date.new(freeze_time.year, freeze_time.month, freeze_time.day)
        expect(available_slots.values.include?(appointment.start_timestamp)).to be_falsey

      end
    end

  end

  describe '#next_available_slot' do
    context 'doctor has no appointment' do
      it "should return next available slot" do
        doctor = doctors(:two)

        next_slot = DoctorAvailableSlotService.new(doctor).next_available_slot

        expect(next_slot).to be > freeze_time
        expect(next_slot.hour).to be doctor.start_time.hour
        expect(next_slot.min).to be doctor.start_time.min
      end
    end

    context "if doctor has appointments" do
      it "should exclude all the booked appointment timing" do
        doctor = doctors(:one)
        appointment = doctor.appointments.create!({
                                                    doctor_id: 1,
                                                    user_id: 2,
                                                    start_timestamp: '2023-02-01 06:30:00 UTC',
                                                    end_timestamp: '2023-02-01 07:30:00 UTC',
                                                    currency: 'INR',
                                                    amount: 50,
                                                  })

        next_available_slot = DoctorAvailableSlotService.new(doctor).next_available_slot

        expect(next_available_slot).to be > appointment.start_timestamp
      end
    end
  end
end