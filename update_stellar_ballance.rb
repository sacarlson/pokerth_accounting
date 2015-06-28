#!/usr/bin/ruby
require 'sqlite3'
require './class_payment'
# update ballance of players list with stellar accounts holdings in local sqlite database

account_log_file="account_log.pdb"
account_dir=File.expand_path('~/.pokerth/accounts/')+"/"
Dir.mkdir(account_dir) unless File.directory?(account_dir)
full_account_log_file=account_dir+account_log_file
stellar = Payment.new
db = SQLite3::Database.open full_account_log_file
db.execute "PRAGMA journal_mode = WAL"
stm = db.prepare "SELECT * FROM Players " 
    rs = stm.execute
    rs.each do |row|
      puts "row = #{row}"
      puts "row[1] = #{row[1]}"
      accID = row[3]
      stellar.set_account(accID)
      playername = row[1]
      ballance = (stellar.check_balance.to_i)/1000000
      if ballance.to_s == "fail"
        puts "bad account #{accID} for player #{playername} will set to zero"
        db.execute("UPDATE Players SET AccBal = 0 WHERE Name = '#{playername}'")
      else
        puts "AccBal = #{ballance}"       
        puts "playername #{playername}"
        db.execute("UPDATE Players SET AccBal = #{ballance} WHERE Name = '#{playername}'")
      end      
    end   
