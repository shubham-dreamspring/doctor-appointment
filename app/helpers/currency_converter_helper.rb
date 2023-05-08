# frozen_string_literal: true
require 'uri'
require 'net/http'

module CurrencyConverterHelper

  def currency_converter(base_currency: 'INR', base_amount:, target_currency:)

    url = URI("https://#{ENV['RAPID_API_HOST']}/v1/convertcurrency?have=#{base_currency}&want=#{target_currency}&amount=#{base_amount}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV['RAPID_API_X_KEY']
    request["X-RapidAPI-Host"] = ENV['RAPID_API_HOST']

    response = http.request(request)
    JSON.parse response.read_body
  end
end
