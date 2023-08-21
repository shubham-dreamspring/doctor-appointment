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
        available_slots = DoctorAvailableSlotService.new(doctors(:two)).all_available_slots

        expect(available_slots.keys[0]).to eql Date.new(freeze_time.year, freeze_time.month, freeze_time.day)
        expect(available_slots[available_slots.keys[0]].size).to eql 3
        expect(available_slots[available_slots.keys[0]][0]).to eql freeze_time + 1.minute
      end
    end

    context "if doctor has appointments" do
      it "should exclude all the appointments" do
        available_slots = DoctorAvailableSlotService.new(doctors(:one)).all_available_slots

        expect(available_slots.keys[0]).to eql Date.new(freeze_time.year, freeze_time.month, freeze_time.day)
        expect(available_slots[available_slots.keys[0]].size).to eql 2

      end
    end

  end

  describe '#next_available_slot' do
    context 'doctor has no appointment' do
      it "should return next available slot" do
        next_slot = DoctorAvailableSlotService.new(doctors(:two)).next_available_slot

        expect(next_slot.to_i).to be (freeze_time + 1.minute).to_i
      end
    end

    context "if doctor has appointments" do
      it "should exclude all the booked appointment timing" do
        next_slot = DoctorAvailableSlotService.new(doctors(:one)).next_available_slot

        expect(next_slot.to_i).to be > (doctors(:one).appointments.last.end_timestamp).to_i
      end
    end
  end
end