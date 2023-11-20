#!/bin/bash

# Start the first process
service tinyproxy start > /var/log/tinyproxy.log 2>&1 &

# Start the second process
service tor start &

# Start the Flask application
cd /etc/tinyproxy/web/
python3 app.py > /var/log/flask.log 2>&1 &

tail -f /var/log/tinyproxy.log /var/lib/tor/notice.log /var/log/flask.log

# Wait for any process to exit
wait -n

# Exit with the status of the process that exited first
exit $?



