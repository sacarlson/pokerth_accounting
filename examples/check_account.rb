#!/usr/bin/ruby
require './class_payment'

#account = "gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x"
#account = "gPG3YuL7fXA4BtGrW5ZgaQ3JbGsENVj2Jn"
account = "gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF"
#account = "gnMB23LwD3eUq3MoNRPeKHSYLGUupx5VFE"
#account = "gKZtQayqwPGWUbTcR8tGCBTNSE4RqxS1B"
#account = "gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF"
#account = "gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x"
#account = "gBuYT5AQpjw1mEiDBJNJshtV3GyV5A2UKA"
#account = "gKEDJYrVwF8qcFx3gdsLurKoiA9ZiEBSew"
#account = "gpHUkTY9c7qviqSbAkPMm5v9ZyTDho9GAE"
#account = "gUaWM6aUBE9kywHiU74PtcJwrgDzTg6sxH"
#account = "g9qDRMCdYiSTvpjj9fJbkjabzB9DwBMScG"
account = "gpBiKGiK44iK35L3LCocsJydicjdpUdbGM"
# "sfinqDFdBeAoHHVdqe6wqBqSg1PaYmPLHTzBCTfSSmJ17zhXABu",


stellar = Payment.new
stellar.set_account(account)
data = stellar.account_lines
puts "account lines: #{data}"

puts "CHP ballance"
chp = bal_CHP(account).to_i
puts ""
puts "#{bal_STR(account).to_i}"




