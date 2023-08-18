require_relative '../../app/services/currency_converter_service'
require "rails_helper"

RSpec.describe CurrencyConverterService do
  describe "#convert_currency_api", type: :helper do
    it "returns the conversion rates" do
      conversion_rates = CurrencyConverterService.convert_currency_api

      expect(conversion_rates).not_to be_nil
      expect(conversion_rates['USD']).to be_a_kind_of(Numeric)
    end
  end
end