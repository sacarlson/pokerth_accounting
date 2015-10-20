#!/usr/bin/ruby
require 'yaml'
require './class_payment'

amount = 6000
to_account = "gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE"

result = bal_STR(to_account)
puts "#{result}"

str_funds_pair = YAML.load(File.open("./secret_str_funds_pair.yml")) 

result = send_native(str_funds_pair, to_account, amount)
puts "#{result}"
sleep 15
result = bal_STR(to_account)
puts "#{result}"

