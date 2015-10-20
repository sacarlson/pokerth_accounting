
require 'rest-client'
url = "https://google.com"
url = "https://test.stellar.org:9002"
#url = "https://stellar.org"
#url = 'https://horizon-testnet.stellar.org'
#url = "https://live.stellar.org:9002"
data = "test"
#postdat = RestClient::Resource.new(url, :ssl_version => 'TLSv1').post(data)
#postdat = RestClient::Resource.new(url, :ssl_version => 'SSLv23').get
#postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').get
postdat = RestClient::Resource.new(url, :ssl_ciphers => 'DEFAULT:!DH').get
#postdat = RestClient::Resource.new(url, :ssl_ciphers => 'AES256-GCM-SHA384').get
#postdat = RestClient::Resource.new(url, :ssl_version => 'TLSv1.2').get

puts "#{postdat}"
