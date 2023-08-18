module AppointmentHelper
  def currency_converter(currency, amount)
    conversion_rate = CurrencyConverterService.currency_conversion_rate
    conversion_rate[currency] * amount
  end
end