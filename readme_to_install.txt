# be sure to install these packages before you run pokerth_accounting.rb  on linux mint or ubuntu or debian:
# sudo apt-get install ruby-full sqlite3 libsqlite3-dev ruby-sqlite3 build-essential sqlitebrowser pokerth
# sudo gem install sys-proctable
# sudo gem install rest-client
# sudo gem install json
# sudo gem install sqlite3

or run sudo ./install_dependencies.sh  that will do the above for you

when run on linux you must run pokerth (the poker game) first for about 4 secounds to be sure the log files have been created before you run pokerth_accounting.rb
I wrote a script that does this for you but the paths need to be edited to match your file locations see start_set.sh thats included in this package
this is the file that I setup a shortcut to run on my desktop to run both pokerth and pokerth_accounting.rb
on first run it should be started on a terminal to see debug info to see that it runs ok firsts.

on windows we will have to change the directory path in pokerth_accounting.rb at lines 16 and 17:
log_dir=File.expand_path('~/.pokerth/log-files/')+"/"
account_dir=File.expand_path('~/.pokerth/accounts/')+"/"

to something windows can find.  I have not tried to install pokerth on windows yet to determine where this might be yet.

there will also be a problem at line 618 that won't work on windows.  I have not researched yet to find what windows will need to do there.
system("killall pokerth")

we have had someone install this on windows but just to use the class_payment.rb and some of the stellar tools also included in this package send_stellar.rb, check_account.rb, send_currency.rb and a few others
example to run in windows in a command window: ruby check_account.rb
