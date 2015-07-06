# this script brings up both pokerth and pokerth_accounting.rb in the correct sequence on a linux system
# you will have to modify this file to point to the directory you have these files installed
nohup /home/sacarlson/github/pokerth/pokerth &
sleep 5
/home/sacarlson/github/poker_accounting/pokerth_accounting.rb
