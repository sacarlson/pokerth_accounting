#!/usr/bin/env ruby

require 'stellar-base'

#b64 = "AAAAAAAAAAD////7AAAAAA=="
b64 = 't1qpS2SGmIWfZXnpmlFsZBt6JYb2+YIUC5RcngrmvCoAAAAAAAAD6P////8AAAABAAAAAAAAAAP////5AAAAAA=='

# decode to the raw byte stream
bytes = Stellar::Convert.from_base64 b64

# decode to the in-memory TransactionResult
tr = Stellar::TransactionResult.from_xdr bytes

# the actual code is embedded in the "result" field of the 
# TransactionResult.
puts tr.result.code

