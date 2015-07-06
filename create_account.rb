#!/usr/bin/ruby
require 'yaml'
require './class_payment'

amount = 10000

#from_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 
#to_pair =  {"account"=>"gKzt...","secret"=>"sfyq..."} 

#pair_set = {"from_pair"=>from_pair, "to_pair"=>to_pair}
#File.open("./secret_pair.yml", "w") {|f| f.write(pair_set.to_yaml) }

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

if !File.exist?('./secret_new_test_pair.yml')
  new_pair = create_new_account()
  File.open("./secret_new_test_pair.yml", "w") {|f| f.write(new_pair.to_yaml) }
else
  puts "file secret_new_test_pair.yml already present"
  new_pair = YAML.load(File.open("./secret_new_test_pair.yml"))
end


#from_pair = pair_set["from_pair"]
#to_pair = pair_set["to_pair"]
to_pair = new_pair

puts "to pair:  #{to_pair}"

#puts "#{pair_set}"
to_account = to_pair["account"]
from_account = from_pair["account"]

# note for each trust line you add to to_account you will require an aditional 5,000000 STR +20,000000 min ballance
send_native(from_pair, to_account, 60000000)
sleep 15

if FALSE
  add_CHP_trust(from_account,to_pair)
  sleep 15
  send_CHP(from_pair, to_account, amount)
  sleep 15
  check_bal(from_pair["account"])
  check_bal(to_pair["account"])
  exit -1
end

puts "#{add_trust(from_pair["account"],to_pair,"EUR")}"
sleep 15
#stellar = Payment.new
#stellar.set_account(to_account)
#lines = stellar.account_lines
#puts "lines #{lines}"

#exit -1
 
puts "#{add_trust(from_pair["account"],to_pair,"USD")}"
sleep 15
puts "#{send_currency(from_pair, to_pair["account"], amount,"USD")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"EUR")}"
sleep 15
puts "#{send_currency(from_pair, to_pair["account"], amount,"EUR")}"
sleep 15
check_bal(from_pair["account"])
check_bal(to_pair["account"])

__END__
puts "#{add_trust(from_pair["account"],to_pair,"JPN")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"AUS")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"GPB")}"
puts "send usd"

sleep 15
puts "send eur"

sleep 15
puts "send jpn"
send_currency(from_pair, to_pair["account"], amount,"JPN")
sleep 15
puts "send aus"
puts "#{send_currency(from_pair, to_pair["account"], amount,"AUS")}"
sleep 15
puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"], amount,"GPB")}"
sleep 15
puts "#{add_trust(from_pair["account"],to_pair,"CNY")}"
sleep 15
puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"], amount,"CNY")}"
sleep 15

check_bal(from_pair["account"])
check_bal(to_pair["account"])

#bal_CHP(to_account)
__END__


USD EUR JPN AUS GBP CHP CNY



