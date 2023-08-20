require "rails_helper"

RSpec.describe AppointmentHelper, type: :helper do
  describe "#currency_converter" do
    it "returns the converted amount" do
      allow(CurrencyConverterService).to receive(:currency_conversion_rate) { { 'INR' => 1, 'USD' => 20, 'EUR' => 10 } }

      expect(helper.currency_converter 'USD', 1).to be 20
    end
  end
end