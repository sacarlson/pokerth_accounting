#!/usr/bin/ruby
require './class_payment'
stellar = Payment.new
stellar.set_account("gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF")
#stellar.set_account("gE39dbtDh26W9KKnPkSx1MdLHb8o2Tj1GN")
data = stellar.check_balance
puts "native ballance #{data}"
data = stellar.account_lines
puts "#{data}"
puts "CHP ballance = #{data["result"]["lines"][0]["balance"]}"
