# this script brings up both pokerth and pokerth_accounting.rb in the correct sequence timing on a linux system
MY_PATH="`dirname \"$0\"`"              # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized
if [ -z "$MY_PATH" ] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi
#echo "$MY_PATH"
export PATH=/home/sacarlson/github/pokerth:$PATH
echo $PATH

#nohup pokerth &
#sleep 5

cd $MY_PATH
bundler exec ruby ./pokerth_accounting.rb
