#!/usr/bin/ruby
require './class_payment'

account = "gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x"
#stellar.set_account("gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF")
#stellar.set_account("gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x")


#puts "CHP ballance = #{data["result"]["lines"][0]["balance"]}"

puts "#{bal_CHP(account)}"
puts "#{bal_STR(account)}"
