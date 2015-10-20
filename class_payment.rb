#!/usr/bin/ruby
# payment system for stellar network
#(c) 2015 by sacarlson  sacarlson_2000@yahoo.com
# gem install rest-client
# gem install json
require 'json'
require 'rest-client'

class Payment

  def initialize()
    @data = {"method"=>"submit", "params"=>[{"secret"=>"sfwtw....", "tx_json"=>{"TransactionType"=>"Payment", "Account"=>"gM4Fp...","DestinationTag"=>"31415", "Destination"=>"g4eR...", "Amount"=>{"currency"=>"USD", "value"=>"0", "issuer"=>"gBAd..."}}}]}
    @net = {"server_url"=>"https://test.stellar.org","server_port"=>"9002"}
    @offer = {"method"=>"submit", "params"=>[{"secret"=>"s3q5Z...", "tx_json"=>{"TransactionType"=>"OfferCreate", "Account"=>"ganV...", "TakerGets"=>{"currency"=>"CHP", "value"=>"1500", "issuer"=>"ghj4..."}, "TakerPays"=>{"currency"=>"USD", "value"=>"2.5", "issuer"=>"ghj4..."}}}]}
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
    #postdat = RestClient.post url, data
    postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').post(data)
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

  def set_DestinationTag(tag)
    # tag must be int    
    @data["params"][0]["tx_json"]["DestinationTag"] = tag.to_i.to_s
  end

  def get_DestinationTag
    return @data["params"][0]["tx_json"]["DestinationTag"]
  end

  def get_value
    return @data["params"][0]["tx_json"]["Amount"]["value"]
  end

  def set_currency(currency)    
    @data["params"][0]["tx_json"]["Amount"]["currency"] = currency
  end

  def get_currency
    return @data["params"][0]["tx_json"]["Amount"]["currency"]
  end

  def set_issuer(issuer)
    @data["params"][0]["tx_json"]["Amount"]["issuer"] = issuer
  end

  def get_issuer
    return @data["params"][0]["tx_json"]["Amount"]["issuer"]
  end

  def set_secret(secret)
    @data["params"][0]["secret"] = secret
  end

  def get_secret
    return @data["params"][0]["secret"]
  end

  def set_account(account)
    @data["params"][0]["tx_json"]["Account"] = account
  end

  def get_account
    return @data["params"][0]["tx_json"]["Account"]
  end

  def set_destination(dest)
    @data["params"][0]["tx_json"]["Destination"] = dest
  end

  def get_destination
    return @data["params"][0]["tx_json"]["Destination"]
  end

  def set_trust
    #puts "start set_trust"
    hash = {"method"=>"submit", "params"=>[{"secret"=>"s3wmY....", "tx_json"=>{"TransactionType"=>"TrustSet", "Account"=>"gnwV....", "LimitAmount"=>{"currency"=>"CHP", "value"=>"1e+19", "issuer"=>"gBAd...."}, "Flags"=>131072}}]}
    #puts "#{hash["params"][0]["tx_json"]["LimitAmount"]["issuer"]}"
    hash["params"][0]["tx_json"]["LimitAmount"]["issuer"] = @data["params"][0]["tx_json"]["Amount"]["issuer"]
    hash["params"][0]["secret"] = @data["params"][0]["secret"]
    hash["params"][0]["tx_json"]["Account"] = @data["params"][0]["tx_json"]["Account"]
    hash["params"][0]["tx_json"]["LimitAmount"]["currency"] = @data["params"][0]["tx_json"]["Amount"]["currency"]
    #puts "#{hash}"
    return self.send_hash(hash)
  end

  def book_offer
    #{"method"=>"book_offers", "params"=>[{"taker_gets"=>{"currency"=>"STR"}, "taker_pays"=>{"issuer"=>"gnhP...", "currency"=>"BTC"}}]}
    hash = {"method"=>"book_offers", "params"=>[{"taker_gets"=>{"issuer"=>"gnhP...", "currency"=>"CHP"}, "taker_pays"=>{"issuer"=>"gnhP...", "currency"=>"USD"}}]}
    hash["params"][0]["taker_pays"]["issuer"] = self.get_takerpays["issuer"]
    hash["params"][0]["taker_pays"]["currency"] = self.get_takerpays["currency"]
    hash["params"][0]["taker_gets"]["issuer"] = self.get_takergets["issuer"]
    hash["params"][0]["taker_gets"]["currency"] = self.get_takergets["currency"]
    return self.send_hash(hash)
  end

  def static_path_find
    hash = {"method"=>"static_path_find", "params"=>[{"source_account"=>"ganV...", "destination_account"=>"gBV8...", "destination_amount"=>{"currency"=>"USD", "value"=>"0", "issuer"=>"gBV8..."}}]}
    hash["params"][0]["source_account"] = @data["params"][0]["tx_json"]["Account"]
    hash["params"][0]["destination_account"] = @data["params"][0]["tx_json"]["Destination"]
    hash["params"][0]["destination_amount"]["currency"] = @data["params"][0]["tx_json"]["Amount"]["currency"]
    hash["params"][0]["destination_amount"]["value"] = @data["params"][0]["tx_json"]["Amount"]["value"]
    hash["params"][0]["destination_amount"]["issuer"] = @data["params"][0]["tx_json"]["Amount"]["issuer"]
    return self.send_hash(hash)
  end

  def offer_cancel(offersequence)
    hash = {"method"=>"submit", "params"=>[{"secret"=>"s3q5...", "tx_json"=>{"TransactionType"=>"OfferCancel", "Account"=>"ganV...", "OfferSequence"=>"0"}}]}
    hash["params"][0]["secret"] = @data["params"][0]["secret"]
    hash["params"][0]["tx_json"]["Account"] = @data["params"][0]["tx_json"]["Account"]    
    hash["params"][0]["tx_json"][0]["OfferSequence"] = offersequence.to_s
    return self.send_hash(hash)
  end
  
  def offer_create
    #@offer = {"method"=>"submit", "params"=>[{"secret"=>"s3q5Z...", "tx_json"=>{"TransactionType"=>"OfferCreate", "Account"=>"ganV...", "TakerGets"=>{"currency"=>"USD", "value"=>"1500", "issuer"=>"ghj4..."}, "TakerPays"=>{"currency"=>"BTC", "value"=>"2.5", "issuer"=>"ghj4..."}}}]}
    @offer["params"][0]["tx_json"]["Account"] = @data["params"][0]["tx_json"]["Account"]
    @offer["params"][0]["secret"] = @data["params"][0]["secret"]
    return self.send_hash(@offer)
  end
   
  def set_takerpays(currency,value,issuer)
    #@offer = {"method"=>"submit", "params"=>[{"secret"=>"s3q5Z...", "tx_json"=>{"TransactionType"=>"OfferCreate", "Account"=>"ganV...", "TakerGets"=>{"currency"=>"CHP", "value"=>"1500", "issuer"=>"ghj4..."}, "TakerPays"=>{"currency"=>"USD", "value"=>"2.5", "issuer"=>"ghj4..."}}}]}
    @offer["params"][0]["tx_json"]["TakerPays"]["value"] = value.to_s
    @offer["params"][0]["tx_json"]["TakerPays"]["issuer"] = issuer
    @offer["params"][0]["tx_json"]["TakerPays"]["currency"] = currency 
  end

  def get_takerpays
    return @offer["params"][0]["tx_json"]["TakerPays"]
  end

  def set_takergets(currency,value,issuer)
    @offer["params"][0]["tx_json"]["TakerGets"]["value"] = value.to_s
    @offer["params"][0]["tx_json"]["TakerGets"]["issuer"] = issuer
    @offer["params"][0]["tx_json"]["TakerGets"]["currency"] = currency 
  end

  def get_takergets
    return @offer["params"][0]["tx_json"]["TakerGets"]
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
    #postdat = RestClient.post url, send
    postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').post(send)
    data = JSON.parse(postdat)
    #puts "#{data}}"
    stat = data["result"]["status"].to_s
    if stat == "success" 
      #puts "#{data}"    
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

  def send_currency
    return self.send
  end

  def send
    data = self.to_json
    url = self.server_urlport
    #postdat = RestClient.post url, data
    postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').post(data)
    data = JSON.parse(postdat)
    #stat = data["result"]["status"].to_s
    #puts "send data #{data}"    
    return data   
  end

  def send_hash(hash)
    data = hash.to_json
    url = self.server_urlport
    #postdat = RestClient.post url, data
    postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').post(data)
    data = JSON.parse(postdat)
    #puts "#{data}"    
    return data    
  end   
end
#end class Payment ..................................

def create_new_account()
  if @config["mode"]="V2"
    return  @Utils.create_new_account()
  else
    new_pair = {"account"=>"ghr1b....", "secret"=>"s3x6v....."}
    stellar = Payment.new
    stellar.create_keys
    new_pair["account"] = stellar.last_key_account_id
    new_pair["secret"] = stellar.last_key_master_seed 
    return new_pair
  end
end

def create_new_active_account(acc_issuer_pair)
  # this will create a new random account number pair
  # it will deposit 30_000000 STR into it to allow transactions on the new account. from STR taken from the acc_issuer account
  # it will return with a hash {"account"=>"gj5D....","secret"=>"s3x6v...."} of the newly created account
  new_pair = {"account"=>"ghr1b....", "secret"=>"s3x6v....."}
  stellar = Payment.new
  stellar.create_keys
  new_pair["account"] = stellar.last_key_account_id
  new_pair["secret"] = stellar.last_key_master_seed
  amount = 30000000
  send_native(acc_issuer_pair, new_pair["account"], amount)
  sleep 10
  stellar.set_account(new_pair["account"])
  data = stellar.check_balance
  puts "ballance check #{data}"
  if data.to_i < 20000000
    puts "still no transaction seen will wait 10 more sec"
    sleep 10
    data = stellar.check_balance
    if data.to_i < 20000000
      puts "20 sec no trans, must be problem so send again"
      send_native(acc_issuer_pair, new_pair["account"], amount)
      sleep 15
    end
    data = stellar.check_balance
    puts "ballance check #{data}"
  end
  return new_pair
end

def send_native(from_issuer_pair, to_account, amount)
  if @config["mode"]="V2"
    #in case we forgot to convert to the new system of stellar that already does this conversion from stroops
    #if we ever need to do transactions bigger than this then we best use Utils direct
    if amount > 1000000
      amount = amount / 1000000
    end
    #note from_issuer_pair here is in Stellar::Keypair structure format in V2
    return @Utils.send_native(from_issuer_pair, to_account, amount)
  else
    stellar = Payment.new
    #puts "from account #{from_issuer_pair["account"]}"
    stellar.set_account(from_issuer_pair["account"])
    stellar.set_secret(from_issuer_pair["secret"])
    stellar.set_currency("native")
    #stellar.set_issuer(from_issuer_pair["account"])
    stellar.set_value(amount)
    #stellar.set_DestinationTag(124)
    stellar.set_destination(to_account)
    status = stellar.send_currency
    #puts "status = #{status}"
    return status
  end
end


def add_CHP_trust(issuer_account,to_pair)
  # this will setup trust to accept CHP currency from from_issuer account to to_pair hash {"account"=>"gj5D....","secret"=>"s3x6v...."}   
  currency = "CHP"
  return add_trust(issuer_account,to_pair,currency)
end

def add_trust(issuer_account,to_pair,currency)
  #note in V2 we get to_pair from @config["secret"]
  # this will setup trust to accept CHP currency from from_issuer_pair account to to_pair hash {"account"=>"gj5D....","secret"=>"s3x6v...."} 
  if @config["mode"]="V2"
    to_pair = Stellar::KeyPair.from_seed(@config["secret"])
    return @Utils.add_trust(issuer_account,to_pair,currency)
  else
    stellar = Payment.new
    stellar.set_issuer(issuer_account)
    stellar.set_currency(currency)
    stellar.set_account(to_pair["account"])
    stellar.set_secret(to_pair["secret"])
    stellar.set_trust
  end
end


def send_currency(from_account_pair, to_account, issuer_account, amount, currency)
  if @config["mode"]="V2"
    from_account_pair =  Stellar::KeyPair.from_seed(@config["secret"])
    return @Utils.send_currency(from_account_pair, to_account, issuer_account, amount, currency)
  else
    # pairs {"account"=>"gj5D....","secret"=>"s3x6v...."}
    stellar = Payment.new
    stellar.set_account(from_account_pair["account"])
    stellar.set_secret(from_account_pair["secret"])
    stellar.set_currency(currency)
    stellar.set_issuer(issuer_account)
    stellar.set_value(amount)
    stellar.set_destination(to_account)
    status = stellar.send_currency
    #puts "status = #{status}"
    return status
  end
end


def send_CHP(from_issuer_pair, to_account, amount)
  if @config["mode"]="V2"
    puts "seed: #{@config["secret"]}"
    from_account_pair =  Stellar::KeyPair.from_seed(@config["secret"])
    return @Utils.send_currency(from_issuer_pair, to_account, from_issuer_pair.address, amount, "CHP")
  else
    # this only works if the issuer is the same as the account sending the CHP
    # see send_currency if they are not the same 
    # also must have trust lines already set and active
    # pairs {"account"=>"gj5D....","secret"=>"s3x6v...."}
    currency = "CHP"
    return send_currency(from_issuer_pair, to_account, from_issuer_pair["account"], amount, currency)
  end  
end

def create_new_account_with_CHP_trust(acc_issuer_pair)
  new_pair = create_new_active_account(acc_issuer_pair)
  add_CHP_trust(acc_issuer_pair["account"],new_pair)
  return new_pair
end

def check_bal(account)
  stellar = Payment.new
  stellar.set_account(account)
  data = stellar.account_lines
  #puts "#{data}"
  #puts ""
  #puts ""
  #puts "CHP ballance = #{data["result"]["lines"][0]["balance"]}"
  data = stellar.check_balance
  #puts "#{data}"
  return data
end

def bal_STR(account)
  if @config["mode"]="V2"
    return @Utils.get_native_balance(account)
  else
    stellar = Payment.new
    stellar.set_account(account)
    data = stellar.check_balance
    #puts "native ballance #{data}"
    return data
  end
end

def bal_CHP(account)
  if @config["mode"]="V2"
    return @Utils.get_lines_balance(account,@config["stellarissuer"],@config["currency"])
  else
    stellar = Payment.new
    stellar.set_account(account)
    data = stellar.account_lines
   #puts "#{data}"
    if data["result"]["lines"] == []
      return 0
    else  
      #puts "CHP ballance = #{data["result"]["lines"][0]["balance"]}"
      return data["result"]["lines"][0]["balance"]
    end
  end
end

__END__




