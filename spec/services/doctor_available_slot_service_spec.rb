require_relative '../../app/services/doctor_available_slot_service'
require "rails_helper"
require 'timecop'

RSpec.describe DoctorAvailableSlotService do
  fixtures(:doctors)
  let(:freeze_time) { Time.utc(2023, 2, 1, 6, 29) }

  around do |example|
    Timecop.freeze(freeze_time) do
      example.run
    end
  end

  describe "#all_available_slots", type: :helper do
    it "should return all available slots" do
      available_slots = DoctorAvailableSlotService.new(doctors(:one)).all_available_slots

      expect(available_slots).not_to be_nil
      expect(available_slots[available_slots.keys[0]].size).to eql 3
    end
  end

  describe '#next_available_slot' do
    it "should return next available slot" do

      next_slot = DoctorAvailableSlotService.new(doctors(:one)).next_available_slot

      expect(next_slot.to_i).to be (freeze_time + 1.minute).to_i
    end
  end
end