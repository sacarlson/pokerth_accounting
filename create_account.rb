#!/usr/bin/ruby
require 'yaml'
require './class_payment'

amount = 10000

#from_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 
#to_pair =  {"account"=>"gKzt...","secret"=>"sfyq..."} 

#pair_set = {"from_pair"=>from_pair, "to_pair"=>to_pair}
#File.open("./secret_pair.yml", "w") {|f| f.write(pair_set.to_yaml) }

#str_funds_pair = {"account"=>"g7Wx...","secret"=>"s3Gq..."}
#File.open("./secret_str_funds_pair.yml", "w") {|f| f.write(str_funds_pair.to_yaml) }
str_funds_pair = YAML.load(File.open("./secret_str_funds_pair.yml")) 

if FALSE
  pair_set = begin
    YAML.load(File.open("./secret_pair.yml"))
  rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
  end
else
  from_pair = YAML.load(File.open("./secret_meetreks_issuer_pair.yml")) 
  #from_pair = {"account"=>"gpHU...","secret"=>"sf2GC..."} 
  #File.open("./secret_meetreks_issuer_pair.yml", "w") {|f| f.write(from_pair.to_yaml) }
  puts "from_pair: #{from_pair}"
end

if FALSE
  # if our issuer or str_funds_pair from_pair runs out of STR we will refill it here
  # we get these refill accounts from the stellar faucet
  refill_pair = {"account"=>"g7Wx3...","secret"=>"s3Gqq..."}
  results = send_native(refill_pair,from_pair["account"], 970000000)
  puts "#{results}"
  sleep 13
  chp = bal_CHP(from_pair["account"]).to_i
  puts "#{bal_STR(from_pair["account"]).to_i}"
  exit -1
end 

# if we want to create more funded accounts we would just change this file name and run it again
secret_file = './secret_test_pair_E.yml'
if !File.exist?(secret_file)
  new_pair = create_new_account()
  File.open(secret_file, "w") {|f| f.write(new_pair.to_yaml) }
else
  puts "file #{secret_file} already present, will load it"
  new_pair = YAML.load(File.open(secret_file))
end


#from_pair = pair_set["from_pair"]
#to_pair = pair_set["to_pair"]
to_pair = new_pair

puts "to pair:  #{to_pair}"

#puts "#{pair_set}"
to_account = to_pair["account"]

#from_account is the issuer in this case
from_account = from_pair["account"]

# str_funds_pair is used to fund the activation str for our new accounts
# note for each trust line you add to to_account you will require an aditional 5,000000 STR +20,000000 min ballance so 60,0000 provides enuf for 8 lines max
if bal_STR(to_account).to_i< 20000000
  puts "not enuf funds will deposit some"
  result = send_native(str_funds_pair, to_account, 60000000)
  puts "#{result}"
  sleep 15
end
check_bal(to_pair["account"])

issuer_acc = from_account

if FALSE
  add_CHP_trust(from_account,to_pair)
  sleep 15
  send_CHP(from_pair, to_account, amount)
  sleep 15
  check_bal(from_pair["account"])
  check_bal(to_pair["account"])
  exit -1
end


puts "#{add_trust(from_pair["account"],to_pair,"USD")}"
sleep 15
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"USD")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"EUR")}"
sleep 15
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"EUR")}"
sleep 15
#check_bal(from_pair["account"])
#check_bal(to_pair["account"])

puts "#{add_trust(from_pair["account"],to_pair,"JPN")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"AUS")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"GPB")}"

puts "send jpn"
result = send_currency(from_pair, to_pair["account"],issuer_acc, amount,"JPN")
puts "#{result}"
sleep 15

puts "send aus"
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"AUS")}"
sleep 15

puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"GPB")}"
sleep 15
#check_bal(from_pair["account"])
check_bal(to_pair["account"])
__END__
puts "#{add_trust(from_pair["account"],to_pair,"CNY")}"
sleep 15
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"GPB")}"
sleep 15
puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"],issuer_acc, amount,"CNY")}"
sleep 15

check_bal(from_pair["account"])
check_bal(to_pair["account"])

#bal_CHP(to_account)
__END__


USD EUR JPN AUS GBP CHP CNY



