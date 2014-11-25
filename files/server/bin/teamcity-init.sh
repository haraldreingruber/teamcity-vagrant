#! /bin/sh

# /etc/init.d/teamcity -  startup script for teamcity
export TEAMCITY_DATA_PATH="/srv/.BuildServer"

case $1 in
  start)
    echo "Starting Team City"
    start-stop-daemon --start  -c teamcity --exec /srv/TeamCity/bin/teamcity-server.sh start
    ;;
  stop)
    echo "Stopping Team City"
    start-stop-daemon --start -c teamcity  --exec  /srv/TeamCity/bin/teamcity-server.sh stop
    ;;
  restart)
    echo "Restarting Team City"
    start-stop-daemon --start  -c teamcity --exec /srv/TeamCity/bin/teamcity-server.sh stop
    start-stop-daemon --start  -c teamcity --exec /srv/TeamCity/bin/teamcity-server.sh start
    ;;
  *)
    echo "Usage: /etc/init.d/teamcity {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
