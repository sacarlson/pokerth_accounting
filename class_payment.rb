#!/usr/bin/ruby
# payment system for stellar network
#(c) 2015 by sacarlson  sacarlson_2000@yahoo.com
# gem install rest-client
# gem install json
require 'json'
require 'rest-client'

class Payment

  def initialize()
    @data = {"method"=>"submit", "params"=>[{"secret"=>"sfwtw....", "tx_json"=>{"TransactionType"=>"Payment", "Account"=>"gM4Fp...", "Destination"=>"g4eR...", "Amount"=>{"currency"=>"USD", "value"=>"0", "issuer"=>"gBAd..."}}}]}
    @net = {"server_url"=>"https://test.stellar.org","server_port"=>"9002"}
  end
  
  def server_url
    return @net["server_url"]
  end  
  
  def server_urlport
    return @net["server_url"]+":"+@net["server_port"].to_s    
  end

  def set_server_url(url)
    @net["server_url"]=url
  end

  def set_server_live
    @net["server_url"] = "live.stellar.org"
    @net["server_port"] = "9002"
  end

  def set_server_test
    @net["server_url"] = "test.stellar.org"
    @net["server_port"] = "9002"
  end

  def set_server_port(port)
    @net["server_port"]=port
  end

  def create_keys
    data = '{"method":"create_keys"}'
    url = self.server_urlport
    postdat = RestClient.post url, data
    data = JSON.parse(postdat)
    @last_key = data
    stat = data["result"]["status"].to_s
    if stat == "success"
      return data
    else
      return "fail"
    end 
  end

  def last_key_account_id
    return @last_key["result"]["account_id"]
  end
 
  def last_key_master_seed
    return @last_key["result"]["master_seed"]
  end
   
  def show
    puts "transaction '#{@data}'"
  end  

  def set_value(value)
   @data["params"][0]["tx_json"]["Amount"]["value"] = value.to_s
  end

  def set_currency(currency)    
    @data["params"][0]["tx_json"]["Amount"]["currency"] = currency
  end

  def set_issuer(issuer)
    @data["params"][0]["tx_json"]["Amount"]["issuer"] = issuer
  end

  def set_secret(secret)
    @data["params"][0]["secret"] = secret
  end

  def set_account(account)
    @data["params"][0]["tx_json"]["Account"] = account
  end

  def set_destination(dest)
   @data["params"][0]["tx_json"]["Destination"] = dest
  end

  def set_trust
    puts "start set_trust"
    hash = {"method"=>"submit", "params"=>[{"secret"=>"s3wmY....", "tx_json"=>{"TransactionType"=>"TrustSet", "Account"=>"gnwV....", "LimitAmount"=>{"currency"=>"CHP", "value"=>"1e+19", "issuer"=>"gBAd...."}, "Flags"=>131072}}]}
    #puts "#{hash["params"][0]["tx_json"]["LimitAmount"]["issuer"]}"
    hash["params"][0]["tx_json"]["LimitAmount"]["issuer"] = @data["params"][0]["tx_json"]["Amount"]["issuer"]
    hash["params"][0]["secret"] = @data["params"][0]["secret"]
    hash["params"][0]["tx_json"]["Account"] = @data["params"][0]["tx_json"]["Account"]
    hash["params"][0]["tx_json"]["LimitAmount"]["currency"] = @data["params"][0]["tx_json"]["Amount"]["currency"]
    #puts "#{hash}"
    return self.send_hash(hash)
  end

  def account_lines
    hash = {"method"=>"account_lines", "params"=>[{"account"=>"ghr1...."}]}
    hash["params"][0]["account"] = @data["params"][0]["tx_json"]["Account"]
    return self.send_hash(hash)
  end

  def check_balance
    data = '{"method":"account_info","params":[{"account":"'
    send = data + @data["params"][0]["tx_json"]["Account"] + '"}]}'
    url = self.server_urlport
    postdat = RestClient.post url, send
    data = JSON.parse(postdat)
    #puts "#{data}}"
    stat = data["result"]["status"].to_s
    if stat == "success" 
      puts "#{data}"    
      return data["result"]["account_data"]["Balance"].to_s    
    else
      return "fail"
    end
  end

  def to_json
    if @data["params"][0]["tx_json"]["Amount"]["currency"] == "native"
      @data["params"][0]["tx_json"]["Amount"] = @data["params"][0]["tx_json"]["Amount"]["value"]    
    end
    return @data.to_json    
  end

  def send
    data = self.to_json
    url = self.server_urlport
    postdat = RestClient.post url, data
    data = JSON.parse(postdat)
    stat = data["result"]["status"].to_s
    #puts "send data #{data}"
    if stat == "success"
      return data
    else
      return "fail"
    end   
  end

  def send_hash(hash)
    data = hash.to_json
    url = self.server_urlport
    postdat = RestClient.post url, data
    data = JSON.parse(postdat)
    puts "#{data}"    
    return data    
  end   
end

__END__
# examples
stellar = Payment.new
#data = stellar.create_keys
#puts "#{stellar.last_key_account_id}"
#puts "#{stellar.last_key_master_seed}"
#puts "#{data}"
#exit -1
#stellar.set_value(250)
#stellar.set_issuer("")
#stellar.set_currency("native")

#stellar.set_account("gJ5DqfJ3czPJVoaW6hZsQEyowpehesgM5E")
stellar.set_account("ghr1Bkm4RYLu3k24oPeQVsZ41rJiy9tNza")
#stellar.set_destination("ghr1Bkm4RYLu3k24oPeQVsZ41rJiy9tNza")

data = stellar.check_balance
puts "#{data}"

puts "#{stellar.send}"

sleep 10
puts "#{stellar.check_balance}"
#stellar.show
#stellar.set_server_live
#puts "#{stellar.server_urlport}"

#puts "#{stellar.to_json}"





