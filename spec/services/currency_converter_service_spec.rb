require_relative '../../app/services/currency_converter_service'
require "rails_helper"

RSpec.describe CurrencyConverterService do
  describe "#convert_currency_api", type: :helper do
    before do
      allow(CurrencyConverterService).to receive(:convert_currency_api) { { 'USD' => 0.233, 'EUR' => 0.34, 'INR' => 1 } }
    end
    it "returns the conversion rates" do
      conversion_rates = CurrencyConverterService.convert_currency_api

      expect(conversion_rates).not_to be_nil
      expect(conversion_rates.include? 'USD').to be_truthy
      expect(conversion_rates.include? 'EUR').to be_truthy
      expect(conversion_rates.include? 'INR').to be_truthy
    end
  end
end