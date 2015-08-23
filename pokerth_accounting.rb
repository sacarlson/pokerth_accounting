#!/usr/bin/ruby
#(c) 2015 by sacarlson  sacarlson_2000@yahoo.com
require 'sys/proctable'
include Sys
require 'sqlite3'
require './class_payment'
# this is the main program that run's in the background with pokerth that pools it's sqlite log files
# to generate payment transactions to other pokerth players Stellar accounts when you loose a hand.

# be sure to install these packages before you run this:
# sudo apt-get install ruby-full sqlite3 ruby-sqlite3
# gem install sys-proctable
# gem install rest-client
# gem install json
# gem install sqlite3

# windows only (planed but not used yet)
#gem install win32-sound

#Sound.play('chimes.wav')
#Sound.play('c:\sounds\hal9000.wav')
#Sound.beep(5000, 3000)


account_log_file="account_log.pdb"
# these path will have to be changed to run it on windows
log_dir=File.expand_path('~/.pokerth/log-files/')+"/"
account_dir=File.expand_path('~/.pokerth/accounts/')+"/"
Dir.mkdir(account_dir) unless File.directory?(account_dir)
full_account_log_file=account_dir+account_log_file
@start_dir = Dir.pwd

# these values were just for function test setup only
log_file="/home/sacarlson/.pokerth/accounts/pokerth-log-2015-07-13_135606.pdb"
playername="sacarlson2"
amount=100
start_cash=10000
gamenumber=1
win_count=0
handID = 8

# presently disabled voice just runs on my computer but later will add to all if you want
# this tells what is being sent to who and tells when you get a deposit delivered from winnings and other status info from pokerth_accounting.
# not sure if it will ever work on windows.  I'll add beeps for them or wav sounds if they want telling of events with sounds using win32-sound
def say(string)
  if @config.nil?
    return
  end
  if @config["audio"] != "Disable"
    #puts "#{@start_dir}"
    if string.nil?
      return
    end
    command = @start_dir+"/say.sh "+ "'" + string + "'"
    #puts "#{command}"
    system(command)
  end
end

#say("poker accounting has started")

def check_db_version(full_account_log_file)
  # this will check to see what user_version of the acounting sqlite database that is now present
  # if it detects an older version it will upgrade it to the new version
  if !File.exist?(full_account_log_file)
    return
  end
  puts "acc_log #{full_account_log_file}"
  db = SQLite3::Database.open full_account_log_file
  result = db.execute("PRAGMA user_version;")
  #puts "#{result[0][0]}"
  if result[0][0] == 0
    puts "old version of account db detected will upgrade to version 1 from 0"   
    result = db.execute("ALTER TABLE Configs ADD COLUMN Chip_Mult REAL;") 
    result = db.execute("ALTER TABLE Configs ADD COLUMN Stellar TEXT;")
    result = db.execute("ALTER TABLE Configs ADD COLUMN Audio TEXT;")
    result = db.execute("ALTER TABLE Configs ADD COLUMN Loop_Time INT;")
    result = db.execute("ALTER TABLE Configs ADD COLUMN Mode INT;")
    result = db.execute("UPDATE Configs SET Chip_Mult = '1'")
    result = db.execute("UPDATE Configs SET Stellar = 'Enable'")
    result = db.execute("UPDATE Configs SET Audio = 'Disable'")
    result = db.execute("UPDATE Configs SET Loop_Time = '2'")
    result = db.execute("UPDATE Configs SET Mode = 'Standard'")
    result = db.execute("PRAGMA user_version = 1;")   
  else
    puts "new accounting version checked ok with version #{result[0][0]}"
    #result = db.execute("PRAGMA user_version = '0';")
  end
end

#check_db_version(full_account_log_file)
#exit -1


def send_surething_player_acc(playernick,stellar_acc,urlaccountserver)
  #url = "poker.surething.biz/player_list"
  #playernick = "test25" 
  #puts "send_sure #{playernick}"
  senturl = urlaccountserver + "?playernick=" + playernick +"&account="+ stellar_acc
  puts "senturl = #{senturl}"
  postdata = RestClient.get senturl
  return JSON.parse(postdata)
end

def update_players_accounts(full_account_log_file, playernick, stellar_acc,accountserver)
  puts "#{full_account_log_file}"
  data = send_surething_player_acc(playernick,stellar_acc,accountserver)
  puts "update #{data}"
  db = SQLite3::Database.open full_account_log_file
  data.each do |row|
    #puts "row = #{row}"
    #puts "#{row[1] +"  " + row[2]}"
    playername = row[1]
    stellar_acc = row[2]    
    #db.execute "INSERT or REPLACE INTO Players VALUES(NULL,'#{playername}',NULL,'#{stellar_acc}',NULL,NULL, NULL,NULL)"
    db.execute "INSERT or IGNORE INTO Players VALUES(NULL,'#{playername}',0,'#{stellar_acc}',NULL,0, 0,0)"
  end
  db.close if db
end

def add_player_to_list(full_account_log_file,playernick)
  db = SQLite3::Database.open full_account_log_file 
  db.execute "PRAGMA journal_mode = WAL;"
  db.execute "INSERT or IGNORE INTO Players VALUES(NULL,'#{playernick}',0,'notset',NULL,0, 0,0);"
  #db.close if db
end

def update_players_list(full_account_log_file, log_file,gamenumber)
  puts "#{full_account_log_file}"
  #data = send_surething_player_acc(playernick,stellar_acc,accountserver)
  db = SQLite3::Database.open log_file
  db.execute "PRAGMA journal_mode = WAL;"
  stm = db.prepare "SELECT * FROM Player WHERE UniqueGameID=#{gamenumber} ;" 
  rs = stm.execute
  rs.each do |row|
    #puts "#{row}"
    puts "#{row[2]}"
    playernick = row[2]
    add_player_to_list(full_account_log_file,playernick)
  end
end
#results = update_players_list(full_account_log_file, log_file)
#puts "#{results}"
#exit -1

def playername_info(playername, full_account_log_file)
  db = SQLite3::Database.open full_account_log_file
  db.execute "PRAGMA journal_mode = WAL"
  stm = db.prepare "SELECT * FROM Players WHERE Name = '#{playername}' LIMIT 1" 
  rs = stm.execute
  rs.each do |row|
    #puts "row = #{row}"
    return row
  end 
end

def playername_to_secret(playername, full_account_log_file)
  return playername_info(playername, full_account_log_file)[4].to_s
end

def playername_to_accountID(playername, full_account_log_file)
  info = playername_info(playername, full_account_log_file)
  #puts "info = #{info}"
  if info.nil?
    #puts "info was nil"
    return "notset"
  else
    return playername_info(playername, full_account_log_file)[3].to_s
  end
end


def get_playernick(log_file)
    # this is to get the nickname you call yourself in the game from pokerth
    #puts "log_file = #{log_file}"
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT * FROM Player WHERE Seat='1' LIMIT 1 " 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row[2] = #{row[2]}"
      return row[2]
    end   
end

#puts "#{get_playernick(log_file)}"
#exit -1


def get_configs(full_account_log_file)
  config_hash = {"playernick"=>"notset", "account"=>"notset", "secreet"=>"notset", "currency"=>"CHP", "paymenturl"=>"test.stellar.org","stellarissuer"=>"gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF", "accountserver"=>"stellar.ddns.net/player_list", "new"=>TRUE, "acc_pair"=>{"account"=>"notset","secret"=>"notset"}, "chip_mult"=>"1", "stellar"=>"Enable", "audio"=>"Disable", "mode"=>"Standard"}
  begin    
    db = SQLite3::Database.open full_account_log_file
    db.execute "CREATE TABLE IF NOT EXISTS Configs(Id INTEGER PRIMARY KEY, 
        PlayerNick TEXT UNIQUE, AccountID TEXT, master_seed TEXT, Currency TEXT, PaymentURL TEXT,Stellar_Issuer TEXT,Account_serverURL TEXT,Chip_Mult REAL, Stellar TEXT, Audio TEXT, Loop_Time INT, Mode TEXT)"
    db.execute "CREATE TABLE IF NOT EXISTS Players(Id INTEGER PRIMARY KEY, 
        Name TEXT UNIQUE, Ballance INT DEFAULT 0, AccountID TEXT, master_seed TEXT, AccBal INT DEFAULT 0, AccBalLast INT DEFAULT 0, AccDiff INT DEFAULT 0)"
    db.execute "CREATE TABLE IF NOT EXISTS Events(Id INTEGER PRIMARY KEY, 
        Name TEXT, Amount INT, GameID INT, Log_file TEXT, AccountID TEXT, Time TEXT)"
    db.execute("PRAGMA user_version = 1;")   


    c = db.execute( "SELECT count(*) FROM Configs ")
   
    #puts "c = #{c[0][0]}"
    exists = c[0][0]
    if exists == 0
      #puts "got here does NOT exist"
      playernick = get_playernick(@full_log_file)
      #puts "playernick from logs = #{playernick}"
      if !ARGV[0].nil?       
        puts "playernick argument detected as #{ARGV[0]}"
        playernick = ARGV[0]
      end
      if playernick.nil? 
        puts "playernick return nil we must have a problem with pokerth log file"
        puts "make sure you have already ran at least 1 game of pokerth Internet Game before running pokerth_accounting.rb so we have logs to see your poker-heroes.com nick"
        puts " option if you know your poker-heroes.com nick name, you can add your nick as a command line param in pokerth_accouting.rb yournick "
        exit -1
      end
      acc_pair = create_new_account()
      config_hash["playernick"]=playernick
      config_hash["account"]=acc_pair["account"]
      config_hash["secreet"]=acc_pair["secreet"]
      config_hash["acc_pair"]=acc_pair
      db.execute "INSERT INTO Configs VALUES(NULL,'#{playernick}','#{acc_pair["account"]}','#{acc_pair["secret"]}','#{config_hash["currency"]}','#{config_hash["paymenturl"]}','#{config_hash["stellarissuer"]}', '#{config_hash["accountserver"]}','1', 'Enable', 'Disable', '2', 'Standard')"
      return config_hash
    else
      #puts "got here does exist"
      db.execute "PRAGMA journal_mode = WAL"
      rs = db.execute "SELECT * FROM Configs " 
      rs.each do |row|
        #puts "row = #{row}"
        #puts "row[2] = #{row[2]}"
        config_hash["new"]=FALSE
        config_hash["playernick"]=row[1]
        config_hash["account"]=row[2]
        config_hash["secret"]=row[3]
        config_hash["acc_pair"]={"account"=>row[2], "secret"=>row[3]} 
        config_hash["currency"]=row[4]  
        config_hash["paymenturl"]=row[5]
        config_hash["stellarissuer"]=row[6]
        config_hash["accountserver"]=row[7]
        config_hash["chip_mult"]=row[8]
        config_hash["stellar"]=row[9]
        config_hash["audio"]=row[10]
        config_hash["loop_time"]=row[11] 
        config_hash["mode"]=row[12]      
      end   
    end

  rescue SQLite3::Exception => e 
    
    puts "Exception occurred in get_configs "
    puts e
    
  ensure
    db.close if db
  end
  db.close if db
  return config_hash
end

#puts "#{get_configs(full_account_log_file)}"
#exit -1

def update_account_log(full_account_log_file, log_file, playername,amount,gamenumber)
  #puts "playername = #{playername} amount #{amount}"
  amount = amount.round(2)
  begin    
    db = SQLite3::Database.open full_account_log_file
    db.execute "CREATE TABLE IF NOT EXISTS Players(Id INTEGER PRIMARY KEY, 
        Name TEXT UNIQUE, Ballance INT DEFAULT 0, AccountID TEXT, master_seed TEXT, AccBal INT DEFAULT 0, AccBalLast INT, AccDiff INT DEFAULT 0)"
    db.execute "CREATE TABLE IF NOT EXISTS Events(Id INTEGER PRIMARY KEY, 
        Name TEXT, Amount INT, GameID INT, Log_file TEXT, AccountID TEXT, Time TEXT)"
  
    db.execute "UPDATE Players SET Ballance = Ballance + #{amount} WHERE Name = '#{playername}'"
   
    timestr = DateTime.now
    #puts "time = #{timestr}"
    accountID = playername_to_accountID(playername, full_account_log_file)
    db.execute("INSERT INTO Events VALUES(NULL,'#{playername}','#{amount}','#{gamenumber}','#{log_file}','#{accountID}', '#{timestr}')")   
    
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred in update_account_log"
    puts e
    
  ensure
    db.close if db
  end
  db.close if db
end
#playername = "zipperhead"
#update_account_log(full_account_log_file, log_file,playername,amount,gamenumber)
#exit -1


def proc_exists(procname)
  Sys::ProcTable.ps.each { |ps|
    if ps.name.downcase == procname    
      return TRUE
    end
  }
  return FALSE
end


def get_start_cash(log_file, gamenumber)

 begin
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT * FROM Game WHERE UniqueGameID=#{gamenumber} LIMIT 2" 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row[2] = #{row[2]}"
      return row[2].to_i
    end   
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred in get_start_cash"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
end

#start_cash = get_start_cash(log_file, gamenumber)
#puts "start_cash = #{start_cash}"
#exit -1

def find_last_log_file(dir_name)
  Dir.chdir dir_name
  filename = Dir.glob("*.pdb").max_by {|f| File.mtime(f)}
  puts "last log filename = #{filename}"
  return filename
end

#find_last_log_file(log_dir)
#exit -1

def check_db_lock( log_file )
  #puts "start check_db_lock"
  fail = FALSE
  begin
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
  rescue SQLite3::Exception => e 

    puts "Exception occurred in check_db_lock"
    puts e
    fail = TRUE
    sleep 5
  ensure   
    #db.close if db
  end
  #db.close if db
  #puts "exit check_db_lock"
  return db
end

#while TRUE do
#check_db_lock(log_file)
#end
#exit -1

def find_max_game( log_file)
 
 begin
    #db = check_db_lock( log_file )
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT max(UniqueGameID) FROM Game LIMIT 1" 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row[1] = #{row[0]}"
      return row[0].to_i
    end   
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred in find_max_game"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
  stm.close if stm
  db.close if db
end

#maxgame = find_max_game( log_file)
#puts "maxgame = #{maxgame}"
#exit -1

def find_max_hand_in_game (log_file, gamenumber)
  #puts "log_file in find_max_hand #{log_file}"
  
  begin
    #db = check_db_lock( log_file )
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    #puts "db ok"
    stm = db.prepare "SELECT max(HandID) FROM Hand  WHERE UniqueGameID=#{gamenumber} LIMIT 1" 
    #puts "stm ok"
    rs = stm.execute
    #puts "rs ok"
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row[0] = #{row[0]}"
      return row[0].to_i
    end   
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred in find_max_hand_in_game"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
  stm.close if stm
  db.close if db
end

#maxhand = find_max_hand_in_game(log_file, gamenumber)
#puts "maxhand = #{maxhand}"
#exit -1

def seatnumber_to_player( seat, gamenumber, log_file)

  begin
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT * FROM Player WHERE UniqueGameID=#{gamenumber} LIMIT 15" 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      if row[1].to_i == seat.to_i
        return row[2]
      end
    end
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
end


def send_player_chips( seat, amount, gamenumber, log_file,account_dir)
  amount = amount.round(2)
  account_file = account_dir+"account_log.pdb"
  playername = seatnumber_to_player( seat, gamenumber, log_file)
  puts "send player #{playername} in seat #{seat}  #{amount} amount of chips"
  saystring = "sending player #{playername}   #{amount}  chips"
  say(saystring)
  update_account_log(account_file,log_file,playername,amount,gamenumber)
  # setting stellar to Disable will skip sending chips to other players, this puts us into the local only accounting mode
  if @config["stellar"]=="Enable"
    @config = get_configs(account_file)
    amount = amount / @config["chip_mult"]
    puts "after chip_mult calculation you will be sending #{amount} of currency #{@config["currency"]}"
    send_to_accountid = playername_to_accountID(playername, account_file)
    if send_to_accountid != "notset"
      bal = bal_CHP(send_to_accountid).to_i
      if bal > 0
        #update_account_log(account_file,log_file,playername,amount,gamenumber)
        from_acc_accountid = @config["account"]
        from_acc_secret = @config["secret"]
        from_account_pair = {"account"=>from_acc_accountid, "secret"=>from_acc_secret}
        #puts "#{from_account_pair}"
        #send_CHP(from_issuer_pair, send_to_accountid, amount)
        #result = send_currency(from_issuer_pair, send_to_accountid, amount,@config["currency"])
        #puts "issuer #{@config["stellarissuer"]}"
        result = send_currency(from_account_pair, send_to_accountid, @config["stellarissuer"], amount, @config["currency"])
        #puts "#{result}"
        sleep 12
        stellar = Payment.new
        stellar.set_account(send_to_accountid)
        data = stellar.account_lines
        #puts "after deposit lines #{data}"
      else
        puts "winner #{playername} didn't have required CHP funds or lines of credit to allow payment, must have more than zero"
      end
    else
      puts "player #{playername} has no Stellar account number listed so no payment sent"
    end
  end  
end
#name = seatnumber_to_player(8,5,log_file)
#puts "name = #{name}"
#send_player_chips(8,100,5,log_file)
#exit -1


def player_seat_account_add( seat, amount, gamenumber, log_file,account_dir)
  #this will add this ammount to this players total_sent in the players Ballance in account local sqlite file records
  playername = seatnumber_to_player( seat, gamenumber, log_file)
  return player_sent_me(playername,amount,account_dir)
end


def player_sent_me(playername,amount,account_dir)
  #this will add this ammount to this players total_sent in the players Ballance in account file records
  account_file = account_dir+"account_log.pdb"
  db = SQLite3::Database.open account_file
  db.execute "PRAGMA journal_mode = WAL"
  db.results_as_hash = true
  return db.execute "UPDATE Players SET Ballance = Ballance + #{amount} WHERE Name = '#{playername}'"     
end
#playername = "surething"
#amount = 10
#result = player_sent_me(playername,amount,account_dir)
#puts "#{result}"
#exit -1

def player_seat_account_ballance(seat, gamenumber, log_file,account_dir)
  playername = seatnumber_to_player( seat, gamenumber, log_file)
  return player_account_ballance(playername, account_dir)
end

def player_account_ballance(playername, account_dir)
  #this is the present value seen in the account log for this player
  # don't confuse this with what is seen in pokerth log_file
  # this should become the accumulated ballance of all the games played with player from the start of account log creation
  # it could be positive or negitive, positive ballance means you have sent him more money then he has sent you
  account_file = account_dir+"account_log.pdb"
  db = SQLite3::Database.open account_file
  db.execute "PRAGMA journal_mode = WAL"
  db.results_as_hash = true
  #return db.execute "UPDATE Players SET Ballance = Ballance + #{amount} WHERE Name = '#{playername}'" 
  stm = db.prepare "SELECT * FROM Players WHERE Name = '#{playername}'"       
  rs = stm.execute
  rs.each do |row|
    #puts "#{row}"
    #puts "#{row["Ballance"]}"
    return row["Ballance"]    
  end
end
#playername = "zipperhead"
#result = player_account_ballance(playername,account_dir)
#puts "#{result}"
#exit -1

def get_players_cash_holdings(log_file, gamenumber, handID, start_cash)
  #return an hash with each players cash holdings at this point in gamenumber, handID with this start_cash. the players are id by seat number in hash string
  hash = {"1"=>start_cash, "2"=>start_cash, "3"=>start_cash, "4"=>start_cash, "5"=>start_cash, "6"=>start_cash, "7"=>start_cash, "8"=>start_cash, "9"=>start_cash, "10"=>start_cash}
  if handID < 1
    return hash
  end 
  db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    db.results_as_hash = true
    stm = db.prepare "SELECT * FROM Hand WHERE UniqueGameID=#{gamenumber} AND HandID = #{handID} LIMIT 2"    
    rs = stm.execute
    rs.each do |row|
      #puts "#{row}"
      hash["1"] = row['Seat_1_Cash'].to_i
      hash["2"] = row['Seat_2_Cash'].to_i 
      hash["3"] = row['Seat_3_Cash'].to_i
      hash["4"] = row['Seat_4_Cash'].to_i
      hash["5"] = row['Seat_5_Cash'].to_i
      hash["6"] = row['Seat_6_Cash'].to_i
      hash["7"] = row['Seat_7_Cash'].to_i
      hash["8"] = row['Seat_8_Cash'].to_i
      hash["9"] = row['Seat_9_Cash'].to_i
      hash["10"] = row['Seat_10_Cash'].to_i
    end
    return hash 
end

#result = get_players_cash_holdings(log_file, gamenumber, handID, start_cash)
#puts "#{result}"
#exit -1

def get_cash_change_last_hand(log_file, gamenumber, handID, start_cash)
  # this will return a hash of each player number with the change in cash from the last hand
  #say("hand number #{handID}")
  hash = {"1"=>0, "2"=>0, "3"=>0, "4"=>0, "5"=>0, "6"=>0, "7"=>0, "8"=>0, "9"=>0, "10"=>0}
  if handID <= 1
    return hash
  end
  present = get_players_cash_holdings(log_file, gamenumber, handID, start_cash)
  #puts "present #{present}"
  last = get_players_cash_holdings(log_file, gamenumber, handID - 1, start_cash)
  #puts "last #{last}"
  present.each do |x|
    #puts "#{x}"
    # x[0] = seat number in string  x[1] = value of this seat number
    #puts "#{x[0]} #{last[x[0]]}"
    z = x[1] - last[x[0]]
    #puts "z = #{z}"
    hash[x[0]] = z
  end
  return hash
end

#result = get_cash_change_last_hand(log_file, gamenumber, handID, start_cash)
#puts "diff #{result}"
#exit -1

def count_winners(log_file, gamenumber, handID, start_cash)
  #return a positive number of winners in this hand not counting you if you are a looser, if you didn't loss or win anything return 0
  # return negitive count if you player #1 was the winner with a negitive number returned for the number or loosers
  change = get_cash_change_last_hand(log_file, gamenumber, handID, start_cash)
  if change["1"] == 0
    return 0
  end
  if change["1"] > 0
    count = 0
    change.each do |x|
      #puts "#{x}"
      if x[1] < 0
        count = count - 1
      end
    end
  else
    count = 0
    change.each do |x|
      #puts "#{x}"
      if x[1] > 0
        count = count + 1
      end
    end
  end
  return count
end

#result = count_winners(log_file, gamenumber, handID, start_cash)
#puts "#{result}"
#exit -1

def we_have_game_winner(log_file, gamenumber)
  # we have game winner will return 0 if no winner of the game yet,  will return seat of the winner if final winner of this game has won
  begin
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT * FROM Action WHERE UniqueGameID=#{gamenumber} AND Action='wins game' LIMIT 2" 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row 4 = #{row[4]}"
      return row[4]
    end
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
  return 0
end
#result = we_have_winner(log_file, gamenumber)
#puts "#{result}"
#exit -1

def cash_left(log_file,gamenumber,handID)
   begin
    db = SQLite3::Database.open log_file
    db.execute "PRAGMA journal_mode = WAL"
    stm = db.prepare "SELECT * FROM Hand WHERE UniqueGameID=#{gamenumber} AND HandID=#{handID} LIMIT 2" 
    rs = stm.execute
    rs.each do |row|
      #puts "row = #{row}"
      #puts "row 7 = #{row[7]}"
      return row[7]
    end
  rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
  ensure
    stm.close if stm
    db.close if db
  end
  return 0
end
#handID = 18
#gamenumber = 1
#result = cash_left(log_file,gamenumber,handID)
#puts "#{result}"
#exit -1

def find_change_send_record(log_file, gamenumber, handID, start_cash,account_dir)
  # this looks for account changes in each player including you to find who owes you money or who you owe money to
  # if you owe money it sends the money over Stellar net to each of them and records in Players local records.
  # if they owe you it only records this in there local Players account records

  # count_winners return the number positive of number of winners in this hand not counting you, if you didn't loss or win anything return 0
  # return negitve if you player #1 was the winner with negitive count of loosers
  win_count = count_winners(log_file, gamenumber, handID, start_cash)
  if win_count == 0
    puts "win_count zero"
    #return
  end 
  
  puts "win count #{win_count}"
  change = get_cash_change_last_hand(log_file, gamenumber, handID, start_cash)
  puts "change = #{change}"
  your_change = change["1"]
  puts "your change #{your_change}"
  # find total all pot winnings when your the winner
  totalpot = 0
  other_winners = 0
  change.each do |y|
    if y[0] != "1"
      if y[1] < 0
        totalpot = totalpot + y[1].abs
      else
        other_winners = other_winners + y[1].abs
      end
    end
  end
  #yourshare_mult = totalpot/other_winners
  puts "total pot #{totalpot}"
  puts "other_winners #{other_winners}"
  
  change.each do |x|
    #puts "#{x}"
    if x[0] != "1"
      if ((x[1] > 0) and (win_count > 0))
        puts "#{x}"
        amount = your_change.abs/win_count.abs
        winner_seat = x[0]
        puts "you sent player in seat #{winner_seat}  #{amount} chips"    
        send_player_chips( winner_seat, amount, gamenumber, log_file,account_dir)
        #add the oposite to your own account in this case change positive to negitive
        player_seat_account_add( "1",amount * -1, gamenumber, log_file,account_dir)
      end
      if ((x[1] < 0) and (win_count < 0))
        
        amount = your_change.abs/win_count.abs
        loosing_seat = x[0]
        puts "player in seat #{loosing_seat} sent you #{amount}"
        results =player_seat_account_ballance(loosing_seat, gamenumber, log_file,account_dir)
        puts "player seat #{loosing_seat} account ballance before player_seat_account_add #{results}"
        # note the amount sent here is a positive numbers now so we will invert it to negitive here 
        player_seat_account_add( loosing_seat, amount * -1, gamenumber, log_file,account_dir)
        #add the oposite to your own account in this case they send us negitive number so here we make it positive and add to our account
        player_seat_account_add( "1",amount , gamenumber, log_file,account_dir)
        results = player_seat_account_ballance(loosing_seat, gamenumber, log_file,account_dir)
        puts "player account ballance now #{results}"
      end
    end
  end
end
#@config = get_configs(full_account_log_file)
#handID = 22
#find_change_send_record(log_file, gamenumber, handID, start_cash,account_dir)
#exit -1


def send_winning_hands_chips(log_file, gamenumber, handID, start_cash,account_dir)
  # this is a new version of send_winner_hand_chips to make it easier to read and add more accounting to what players should have sent you
  # so that we can verify that the Stellar transactions worked.  
  # this will detect if there are any winners in this handID, and will setup to pay each of them what you owe them
  # we now acumulate what each player you have every played with has made or lost to you in accounts Players Ballance table
  # later I might add if the ballance is not correct between our local and Stellar ballance,
  # that we can withhold funds for the difference in future games we play with that player.
  say("hand i d #{handID} ")
  winner_seat = we_have_game_winner(log_file, gamenumber).to_i
  #winner_seat = 0
  if winner_seat == 1
    puts "congradulations your the winner, last players will send you the last of there money and change from last hand on record"
    find_change_send_record(log_file, gamenumber, handID, start_cash,account_dir)
    last_holding = get_players_cash_holdings(log_file, gamenumber, handID, start_cash)
    last_holding.each do |x|
      #puts "#{x}"
      if x[0] != "1"
        loosing_seat = x[0]
        amount = x[1]
        if amount > 0
          # reverse sign to negitive as they are sending you money making there ballance negitive
          amount = amount * -1
          puts "player seat #{loosing_seat} sent you #{amount}"
          player_seat_account_add(loosing_seat, amount, gamenumber, log_file,account_dir)
          player_seat_account_add( "1",amount * -1, gamenumber, log_file,account_dir)
        end
      end
    end    
    say("congradulations your the winner of this game, we will now exit poker accounting")
    update_surething(@config["accountserver"])
    say("now exiting accounting")
    exit -1
    return
  end
  if winner_seat > 1  
    amount = cash_left(log_file,gamenumber,handID).to_i
    puts "winner detected, send him last of your money #{amount}"
    say("you have lost this game, we will send last of your funds #{amount} to the winner and exit accounting")
    if amount > 0
      send_player_chips( winner_seat, amount, gamenumber, log_file,account_dir)
      player_seat_account_add( "1",amount * -1, gamenumber, log_file,account_dir)
    end
    # also need to send diff from last recorded hand
    find_change_send_record(log_file, gamenumber, handID, start_cash,account_dir)
    sleep 12
    update_surething(@config["accountserver"])
    say("now exiting accounting")
    exit -1
    return
  end

  find_change_send_record(log_file, gamenumber, handID, start_cash,account_dir)
  return
end

#handID = 7
#result = send_winning_hands_chips(log_file, gamenumber, handID, start_cash,account_dir)
#puts "#{result}"
#exit -1



def run_loop(log_dir,account_dir)
  log_file = find_last_log_file(log_dir)
  full_log_file = log_dir+log_file
  puts "full_log_file = #{full_log_file}"
  puts "log_file: #{log_file}"
  gamenumber = find_max_game( full_log_file)
  #start_cash = get_start_cash(full_log_file, gamenumber)
  #puts "start_cash = #{start_cash}"
  maxhand = find_max_hand_in_game(full_log_file, gamenumber)
  # wait for new game to start or new log file to be created
  account_file = account_dir+"account_log.pdb"
  while TRUE  do    
    newgamenumber = find_max_game( full_log_file)
    puts "newgamenumber = #{newgamenumber}"
    if newgamenumber != gamenumber 
      break
    end
    if proc_exists("pokerth") == FALSE
      puts "pokerth is not detected as running will exit now, you must run pokerth before pokerth_accounting.rb"
      say("poker no longer running will exit accounting now")
      exit -1
    end
    sleep(3)
  end
  puts "new game started" 
  say("new game started") 
  gamenumber = find_max_game(full_log_file)
  start_cash = get_start_cash(full_log_file, gamenumber)
  update_players_list(account_file,full_log_file, gamenumber)
  if @config["stellar"]=="Enable"
    lastbal = bal_CHP(@config["account"]).to_i 
  end 
  while TRUE  do
    if @config["stellar"]=="Enable"
      bal = bal_CHP(@config["account"]).to_i
      if bal > lastbal
        change = bal - lastbal
        say("positive change in ballance of #{change} chips")
      end
      lastbal = bal
    end
    #puts "gamenumber = #{gamenumber}"
    #puts "maxhand = #{maxhand}"
    newmaxhand = find_max_hand_in_game(full_log_file, gamenumber)
    if newmaxhand != maxhand
      # do check
      puts "hand change detected"
      say("hand change detected") 
      send_winning_hands_chips(full_log_file, gamenumber, newmaxhand, start_cash,account_dir)
      maxhand = newmaxhand
    end
    newgamenumber = find_max_game( full_log_file)
    if newgamenumber != gamenumber
      update_surething(@config["accountserver"])
      break
    end
    if proc_exists("pokerth") == FALSE
      puts "pokerth no longer running will exit now"
      say("poker proc no longer running, will exit now")
      # this will update your account ballance on the poker.surething.biz website for people to see
      update_surething(@config["accountserver"])
      exit -1
      break
    end
    # default loop_time is 2 sec
    puts "hand number: #{newmaxhand}"
    sleep(@config["loop_time"].to_i)
    puts" post sleep"
  end

end

def update_surething(urlaccountserver)
  if @config["stellar"]!="Enable"
    puts "stellar not enabled no update_sure needed."
    return
  end
  #url = "poker.surething.biz/player_list"
  #playernick = "test25" 
  to_send = urlaccountserver + "/update.php" 
  puts "#{to_send}"
  #postdata = RestClient.get urlaccountserver + "/update.php" 
  postdata = RestClient.get to_send
  puts "#{postdata}"
  #return JSON.parse(postdata)
end



log_file = find_last_log_file(log_dir)
@full_log_file = log_dir+log_file
check_db_version(full_account_log_file)

@config = get_configs(full_account_log_file)
puts "#{@config}"

 # if stellar is disabled we won't need all this stuf checked, only local accounting in sqlite file will be done
if @config["stellar"]=="Enable"
  send_surething_player_acc(@config["playernick"],@config["account"],@config["accountserver"])
  str = bal_STR(@config["account"])
  puts "#{str}"


  if str == "fail"
    puts "no STR funds in your account found, we will ask poker.surething.biz to send us some (this will take up to 30 secounds so please wait)"
    say("you have no Stellar funds in your account, we will ask sure thing to send you some, please wait 30 seconds")
    update_surething(@config["accountserver"])
    str = bal_STR(@config["account"])
    if str != "fail"
      puts "ok now we got STR #{str} so lets add trust and ask for some CHP from poker.surething.biz"
      puts "add trust stellar issuer #{@config["stellarissuer"]} to pair #{@config["acc_pair"]}"
      add_CHP_trust(@config["stellarissuer"],@config["acc_pair"])
      sleep 12
      update_surething(@config["accountserver"])
    else
      puts "didn't get any STR from poker.surething.biz so maybe try again later or ask a freind for a loan or??, will exit now and kill pokerth"
      say("sorry we failed to get funding from sure thing,, you will have to find funding elsewhere, we will exit poker now")
      add_CHP_trust(@config["stellarissuer"],@config["acc_pair"])
      system("killall pokerth")
      exit -1
    end
  end

  bal = bal_CHP(@config["account"]).to_i
  puts "CHP ballance #{bal}"
  if bal < 11000
    puts "Your CHP chip ballance is bellow 11,000 CHP, you don't have enuf funds to start a game, we will kill pokerth now"
    puts "Talk to Scotty (sacarlson) or one of your freinds to loan you some chips or ??"
    puts "You should also be able to see your CHP ballance at http://poker.surething.biz  look for your pokerth nickname"
    puts " also we will request a donation from surething now in hopes they give you some"
    puts "add trust stellar issuer #{@config["stellarissuer"]} to pair #{@config["acc_pair"]}"
    add_CHP_trust(@config["stellarissuer"],@config["acc_pair"])
    update_surething(@config["accountserver"])
    sleep 15
    bal = bal_CHP(@config["account"]).to_i
    if bal < 11000
      puts "still no money seen delivered from surething, might try again later or barrow some funds from a freind, will shut down pokerth and exit now"
      # note this system call will have to be changed or removed for windows port
      say("I am sorry we were unable to get funds from sure thing, you will have to find funds else where, we will now exit poker game")
      system("killall pokerth")
      exit -1
    end
  end
end

update_players_accounts(full_account_log_file, @config["playernick"],@config["account"],@config["accountserver"])
say("we now have stellar account funding and will start run loop")
run_loop(log_dir,account_dir)

puts "run_loop exited"

