#!/usr/bin/ruby
 #the released stellar ruby isn't working yet, I will have to write my own
require 'stellar'
#account = Stellar::Account.from_seed("s3fu5vCMrfYouKuk2uB1gCD7EsuuBKY9M4qmnniQMBFMWR6Gaqm")
account = Stellar::Account.from_seed("sfUUQZ7Lg814zV7Mkrj4R5mYhKiu1gJveSh13R8utzdpXWy2mfa")
client = Stellar::Client.default_testnet()
# create a random recipients
recipient = Stellar::Account.random
puts "rec = #{recipient}"
exit -1
# make a payment
client.send_payment({
from: account,
to: recipient,
amount: Stellar::Amount.new(1_000000)
}) # => #<OK>
