require 'uri'
require 'net/http'
require 'json'

class CurrencyConverterService

  def self.convert_currency_api
    url = URI("http://api.apilayer.com/fixer/latest?base=INR&symbols=INR,USD,EUR")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request['apikey'] = ENV['RAPID_API_X_KEY']

    JSON.parse(http.request(request).body)['rates']
  end

  def self.cached_conversion_rate
    cached_conversion_rates = Rails.cache.read('conversion_rates')

    if !cached_conversion_rates.nil? && cached_conversion_rates[:timestamp].today?
      return cached_conversion_rates[:conversion_rates]
    end
    nil
  end

  def self.set_cache_conversion_rate
    conversion_rates = convert_currency_api

    Rails.cache.write('conversion_rates', { conversion_rates: conversion_rates, timestamp: Time.now }, expires_in: 1.days)
    conversion_rates
  end

  def self.currency_conversion_rate
    return cached_conversion_rate unless cached_conversion_rate.nil?
    set_cache_conversion_rate
  end
end