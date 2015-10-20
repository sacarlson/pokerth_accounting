#!/usr/bin/ruby
#(c) 2015 by sacarlson  sacarlson_2000@yahoo.com
# note can't publish this yet it has passwords and keys in it in two places.

require 'mysql'
require 'yaml'
require './class_payment'

# we created the security yml file using this setup first
#from_issuer_pair = {"account"=>"gLan...","secret"=>"s3zD..."} 

#File.open("./secret_set.yml", "w") {|f| f.write(from_issuer_pair.to_yaml) }

# load up the secret value pairs from our security file secret_pair.yml to allow us to publish this file to the public 
from_issuer_pair = begin
  YAML.load(File.open("./secret_set.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end


#puts "#{from_issuer_pair}"
#bal = bal_CHP(account)
#puts "#{bal}"



begin
    con = Mysql.new 'localhost', 'pokerth', 'eu8CvrhU7j8NX2Vx', 'pokerth_acc'
    rs = con.query("SELECT * FROM Players")
    n_rows = rs.num_rows
    
    puts "There are #{n_rows} rows in the result set"
    
    n_rows.times do
        #puts rs.fetch_row.join("\s")
        row = rs.fetch_row
        acc = row[2]
        str_bal = bal_STR(acc)
       
        if str_bal != "fail"
          chp_bal =  bal_CHP(acc).to_i
          puts "chp_bal #{chp_bal}  for #{acc}"
          if chp_bal < 200
            puts " sending CHP to #{acc}"
            send_CHP(from_issuer_pair, acc, 100000)
            sleep 10
          end
          rsb = con.query("UPDATE Players SET STR_Bal = #{str_bal} WHERE AccountID = '#{acc}'")
          rsb = con.query("UPDATE Players SET CHP_Bal = #{chp_bal} WHERE AccountID = '#{acc}'")
        else
          amount = 30000000
          send_native(from_issuer_pair, acc, amount)
          sleep 12
          str_bal = bal_STR(acc)
          rsb = con.query("UPDATE Players SET STR_Bal = #{str_bal} WHERE AccountID = '#{acc}'")
        end
    end
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end
