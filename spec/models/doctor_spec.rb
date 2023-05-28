require 'rails_helper'

RSpec.describe Doctor, type: :model do
  context "attributes should be valid" do
    it "fees can't be empty" do
      doctor = Doctor.new({ name: 'Shubham Jain' })
      expect(doctor.invalid?).to be_truthy
    end
    it "name can't be empty" do
      doctor = Doctor.new({ fees: 2 })
      expect(doctor.invalid?).to be_truthy
    end
    it "image_url should be valid" do
      doctor = Doctor.new({ name: 'Shubham Jain', fees: 2 })
      expect(doctor.invalid?).to be_truthy
    end
    it "fees should be greater than 0" do
      doctor = Doctor.new({ name: 'Shubham Jain', fees: -2, image_url: '1.png' })
      expect(doctor.invalid?).to be_truthy
    end
  end
end
