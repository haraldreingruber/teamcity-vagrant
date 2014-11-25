

sudo /etc/init.d/nginx start
#sudo /etc/init.d/teamcity start
export TEAMCITY_DATA_PATH="/srv/.BuildServer"
start-stop-daemon --start  -c teamcity --exec /srv/TeamCity/bin/teamcity-server.sh start
