#!/bin/bash

mkdir -p /var/lib/tor/onion-auth/
chown 100:101 /var/lib/tor/onion-auth/
cp -n /config/torrc.base /etc/tor/torrc
cp -n /config/tinyproxy.base /etc/tinyproxy/tinyproxy.conf
# Start the first process
service tinyproxy start > /var/log/tinyproxy.log 2>&1 &

# Start the second process
service tor start &

# Start the Flask application
python3 /web/app.py > /var/log/flask.log 2>&1 &

tail -f /var/log/tinyproxy.log /var/lib/tor/notice.log /var/log/flask.log

# Wait for any process to exit
wait -n

# Exit with the status of the process that exited first
exit $?



