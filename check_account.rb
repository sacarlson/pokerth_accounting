#!/usr/bin/ruby
require './class_payment'

#account = "gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x"
#account = "gPG3YuL7fXA4BtGrW5ZgaQ3JbGsENVj2Jn"
#account = "gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF"
#account = "gnMB23LwD3eUq3MoNRPeKHSYLGUupx5VFE"
#account = "gKZtQayqwPGWUbTcR8tGCBTNSE4RqxS1B"
#account = "gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF"
#account = "gnumeDpUqqim44a5Hi94wxDeVV3ofhc28x"
account = "gBuYT5AQpjw1mEiDBJNJshtV3GyV5A2UKA"


chp = bal_CHP(account).to_i
puts "#{bal_STR(account).to_i}"

if chp < 11
  puts "it's less"
end


