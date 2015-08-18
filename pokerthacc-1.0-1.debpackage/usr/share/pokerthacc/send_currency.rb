#!/usr/bin/ruby
require 'yaml'
require './class_payment'


#from_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 
#to_pair =  {"account"=>"gKzt...","secret"=>"sfyq..."} 

#pair_set = {"from_pair"=>from_pair, "to_pair"=>to_pair}
#File.open("./secret_pair.yml", "w") {|f| f.write(pair_set.to_yaml) }

amount = 10000

pair_set = begin
  YAML.load(File.open("./secret_pair.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end




from_pair = pair_set["from_pair"]
to_pair = pair_set["to_pair"]

#puts "#{pair_set}"
to_account = to_pair["account"]
from_account = from_pair["account"]

add_CHP_trust(from_account,to_pair)
sleep 12
send_CHP(from_pair, to_account, amount)
sleep 15
check_bal(from_pair["account"])
check_bal(to_pair["account"])

__END__

# note if trust was already added we wouldn't need the add_trust and wouldn't need the secreet side of to_pair to send currency
# in this case we setup trust and send currency
puts "#{add_trust(from_pair["account"],to_pair,"USD")}"
sleep 12
puts "#{add_trust(from_pair["account"],to_pair,"EUR")}"
sleep 12
puts "#{add_trust(from_pair["account"],to_pair,"JPN")}"
sleep 12
puts "#{add_trust(from_pair["account"],to_pair,"AUS")}"
sleep 12
puts "#{add_trust(from_pair["account"],to_pair,"GPB")}"
puts "send usd"
puts "#{send_currency(from_pair, to_pair["account"], amount,"USD")}"
sleep 15
puts "send eur"
puts "#{send_currency(from_pair, to_pair["account"], amount,"EUR")}"
sleep 15
puts "send jpn"
send_currency(from_pair, to_pair["account"], amount,"JPN")
sleep 15
puts "send aus"
puts "#{send_currency(from_pair, to_pair["account"], amount,"AUS")}"
sleep 15
puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"], amount,"GPB")}"
sleep 12
puts "#{add_trust(from_pair["account"],to_pair,"CNY")}"
sleep 12
puts "send gpb"
puts "#{send_currency(from_pair, to_pair["account"], amount,"CNY")}"
sleep 15

check_bal(from_pair["account"])
check_bal(to_pair["account"])

bal_CHP(to_account)
__END__


USD EUR JPN AUS GBP CHP CNY




