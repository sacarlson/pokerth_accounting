#!/usr/bin/ruby
require 'yaml'
require './class_payment'


#from_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 
#to_pair =  {"account"=>"gKzt...","secret"=>"sfyq..."} 

#pair_set = {"from_pair"=>from_pair, "to_pair"=>to_pair}
#File.open("./secret_pair.yml", "w") {|f| f.write(pair_set.to_yaml) }

amount = 10

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

#add_CHP_trust(from_pair["account"],to_pair)
#send_CHP(from_pair, to_pair["account"], amount)
#puts "#{add_trust(from_pair["account"],to_pair,"USD")}"
#puts "#{add_trust(from_pair["account"],to_pair,"EUR")}"
#puts "#{add_trust(from_pair["account"],to_pair,"JPN")}"
#puts "#{add_trust(from_pair["account"],to_pair,"AUS")}"
#puts "#{add_trust(from_pair["account"],to_pair,"GPB")}"
#puts "send usd"
#puts "#{send_currency(from_pair, to_pair["account"], amount,"USD")}"
#sleep 25
#puts "send eur"
#puts "#{send_currency(from_pair, to_pair["account"], amount,"EUR")}"
#sleep 25
#puts "send jpn"
#send_currency(from_pair, to_pair["account"], amount,"JPN")
#sleep 25
#puts "send aus"
#puts "#{send_currency(from_pair, to_pair["account"], amount,"AUS")}"
#sleep 30
#puts "send gpb"
#puts "#{send_currency(from_pair, to_pair["account"], amount,"GPB")}"

#add_CHP_trust(from_account,to_pair)
send_CHP(from_pair, to_account, amount)
sleep 15
check_bal(from_pair["account"])
check_bal(to_pair["account"])

bal_CHP(to_account)
__END__


USD:EUR: JPN:CNY:AUS:GBP


