This server section is run on an apache LAMP server and is optional to install
it is the present method used to share our Stellar.org account numbers that links our pokerth nicknames to accounts
at the time of this writing this server is already setup and running at http://poker.surething.biz/player_list
that puts out json format data used by pokerth_accounting.rb and http://poker.surething.biz that has a human
table format that displays all game players and there stellar accounts and present ballances of STR and CHP.
this is here in the event that others want to have there own player list on another server
or in the event for any resoon they shutdown my site and we need to open a new one.  
ruby is also used if you want to auto fund accounts with STR currency to activate them and some CHP to use to play in the game.

to get ruby section of server section to run you need in adition to ruby to install:
sudo apt-get install libmysqlclient-dev
sudo gem install mysql

you will need to modify rename config.php.example to config.php and edit it match the passwords of the mysql database you 
create.  use pokerth_acc.sql to create a new mysql database.  google to find method of creating database with sql files
if you don't already know.
