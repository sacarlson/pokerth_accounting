#!/usr/bin/ruby
require 'yaml'
require './class_payment'

# we really only need the issuer_pair account number but this is what we now have on file for this account that includes secret also
issuer_pair = YAML.load(File.open("./secret_meetreks_issuer_pair.yml")) 


# this new_test_pair already has trust and curreny ballances setup for meetreks_issuer above that was setup using create_account.rb
# this is the account that we will setup orders with using meetreks trusted issuer address
from_pair = YAML.load(File.open("./secret_new_test_pair.yml"))
puts "from pair #{from_pair}"
#puts "#{pair_set}"
issuer_account = issuer_pair["account"]
puts "issuer_account #{issuer_account}"

from_account = from_pair["account"]

  stellar = Payment.new
  stellar.set_account(from_pair["account"])
  stellar.set_secret(from_pair["secret"])
  stellar.set_takerpays("USD",140,issuer_account)
  stellar.set_takergets("EUR",100,issuer_account)
  results = stellar.offer_create
  puts "#{results}"
  sleep 14
  stellar.set_takerpays("EUR",130,issuer_account)
  stellar.set_takergets("USD",80,issuer_account)
  results = stellar.offer_create
  puts "#{results}"
  sleep 14
  results = stellar.book_offer
  puts "#{results}"
  stellar.set_takerpays("USD",0,issuer_account)
  stellar.set_takergets("EUR",0,issuer_account)
  results = stellar.book_offer
  puts "#{results}"
