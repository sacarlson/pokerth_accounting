#!/usr/bin/ruby
require './class_payment'
require 'yaml'

# we created the security yml file using this setup first
#from_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 
#to_pair =  {"account"=>"gKzt...","secret"=>"sfyq..."} 

#pair_set = {"from_pair"=>from_pair, "to_pair"=>to_pair}
#File.open("./secret_pair.yml", "w") {|f| f.write(pair_set.to_yaml) }

# load up the secret value pairs from our security file secret_pair.yml to allow us to publish this file to the public 
pair_set = begin
  YAML.load(File.open("./secret_pair.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

puts "#{pair_set}"
from_pair = pair_set["from_pair"]
to_pair = pair_set["to_pair"]

to_account = to_pair["account"]
from_account = from_pair["account"]

# fill in these values with the account and amount you want to send
amount = 50
to_account = "gPG3YuL7fXA4BtGrW5ZgaQ3JbGsENVj2Jn"

#get the ballance in STR on the to_account before we send any money
bal_STR(to_account)

#send native (also know as STR) from pair that contains account and secreet number to_account of the value in amount
send_native(from_pair, to_account, amount)

#need to wait 10 or so secound for the money to tranfer over the stellar network
sleep 14

#check the ballance after we sent the money to see if it worked
bal_STR(to_account)
