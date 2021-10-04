#!/bin/bash

while true; do
    inotifywait --exclude .swp -e create -e modify -e delete -e move /etc/nginx/conf.d /etc/nginx/modules-enabled /etc/nginx/sites-enabled
        
    # Test nginx config before attempting to restart.
    nginx -t
    if [ $? -eq 0 ]; then
        # Config test passed - loading config.
        echo "Detected Nginx Configuration Change"
        echo "Executing: nginx -s reload"
        nginx -s reload
    else
        echo "Config test did not pass. Please fix config and try again."
    fi
done
