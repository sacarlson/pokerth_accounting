# be sure to install these packages before you run pokerth_accounting.rb  on linux mint or ubuntu or debian:
# sudo apt-get install ruby-full sqlite3 ruby-sqlite3
# gem install sys-proctable
# gem install rest-client
# gem install json
# gem install sqlite3

when run on linux you must run pokerth first for about 4 secounds to be sure the log files have been created before you run pokerth_accounting.rb

on windows we will have to change the directory path in pokerth_accounting.rb at lines 16 and 17:
log_dir=File.expand_path('~/.pokerth/log-files/')+"/"
account_dir=File.expand_path('~/.pokerth/accounts/')+"/"

to something windows can find.  I have not tried to install pokerth on windows yet to determine where this might be yet.

there will also be a problem at line 618 that won't work on windows.  I have not researched yet to find what windows will need to do there.
system("killall pokerth")

we have had someone install this on windows but just to use the class_payment.rb and some of the stellar tools including send_stellar.rb, check_account.rb, send_currency.rb
to run in windows in a command window: ruby check_account.rb
