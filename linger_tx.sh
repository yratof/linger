#!/bin/bash
# /etc/init.d/linger_tx

### BEGIN INIT INFO
# Provides:          linger_tx
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: linger_tx
# Description:       This service is used to replay probe requests
### END INIT INFO

case "$1" in
    start)
        # Wait 5 seconds for tty1 to become ready. Must be a cleaner way?
        sleep 5
        ## Wait 5 extra seconds so we know mon0 has been populated and
        ## the next monitor mode device will be mon1
        #sleep 5
        echo "Starting linger_tx" > /dev/tty1
        #sudo airmon-ng start wlan2 1>/dev/null 2>/home/pi/linger/log
        sudo /home/pi/linger/linger_tx.py -i wlan2 -v 1> /dev/tty1 2>/home/pi/linger/log
        ;;
    stop)
        echo "Stopping linger_tx" > /dev/tty1
        sudo kill `ps -eo pid,command | grep "linger_tx.py" | grep -v grep | head -1 | awk '{print $1}'`1>/dev/null 2>/home/pi/linger/log
        #sudo airmon-ng stop mon1 1>/dev/null
        echo "Done" > /dev/tty1
        ;;
    *)
        echo "Usage: /etc/init.d/linger_tx start|stop"
        exit 1
        ;;
esac

exit 0