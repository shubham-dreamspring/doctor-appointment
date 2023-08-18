require "rails_helper"

RSpec.describe AppointmentHelper, type: :helper do
  describe "#currency_converter" do
    it "returns the converted amount" do
      expect(helper.currency_converter 'USD', 1).to be_a_kind_of(Numeric)
    end
  end
end