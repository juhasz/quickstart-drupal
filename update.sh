cd ~/quickstart

echo "Updating Quickstart"
git checkout master 2> /dev/null;
git pull; 

bash updates/0001.sh
