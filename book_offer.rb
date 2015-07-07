#!/usr/bin/ruby
require 'yaml'
require './class_payment'
  # gpHUK... is  meetreks test issuer account on testnet
  issuer_account = "gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE"
  stellar = Payment.new
  # note that the center value field is zero as it is not used in the book_offer function
  stellar.set_takerpays("USD",0,issuer_account)
  stellar.set_takergets("EUR",0,issuer_account)
  results = stellar.book_offer
  puts "#{results}"
  puts ""
  puts ""
  # I'm not sure what direction we have trades on EUR and USD so we look at both directions for takerpays and takergets
  stellar.set_takerpays("EUR",0,issuer_account)
  stellar.set_takergets("USD",0,issuer_account)
  results = stellar.book_offer
  puts "#{results}"
