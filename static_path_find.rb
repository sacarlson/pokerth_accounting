#!/usr/bin/ruby
require 'yaml'
require './class_payment'

  issuer_account = "gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE"
  stellar = Payment.new
  # my test account gHVS... that has trust and ballances on issuer gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE
  # in static_path_find account is used for source_account
  stellar.set_account("gHVS8kkZVfhUcbv11hpRVGMB7r8gEwhzKm")
  #gBuY... is meetreks users account we will play with here that also has ballances and trust from issuer gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE
  # and will use it as our destination address here
  stellar.set_destination("gBuYT5AQpjw1mEiDBJNJshtV3GyV5A2UKA")
  stellar.set_issuer(issuer_account)
  stellar.set_currency("USD")
  stellar.set_value(1)
  results = stellar.static_path_find
  puts "#{results}"
  puts " "
  stellar.set_currency("EUR")
  results = stellar.static_path_find
  puts "#{results}"
