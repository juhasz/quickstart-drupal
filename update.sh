cd ~/quickstart

QUICKSTART=7.x-0.9beta1

echo "Updating Quickstart"
git checkout master 2> /dev/null;
git pull; 
git checkout $QUICKSTART 2> /dev/null

bash updates/0001.sh
