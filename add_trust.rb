#!/usr/bin/ruby
require './class_payment'
require 'yaml'

from_pair = YAML.load(File.open("./secret_set.yml"))
#from_pair =  {"account"=>"gLanQ...","secret"=>"s..."} 

to_pair = {"account"=>"g9qDRMCdYiSTvpjj9fJbkjabzB9DwBMScG","secret"=>"s3vH..."}
#to_pair = create_new_active_account(from_pair)
puts "to_pair: #{to_pair}"
puts "#{from_pair}"
puts "STR balance #{bal_STR(to_pair["account"])}"

add_trust(from_pair["account"],to_pair,"CHP")

sleep 15
stellar = Payment.new
stellar.set_account(to_pair["account"])
data = stellar.account_lines
puts "account lines: #{data}"
