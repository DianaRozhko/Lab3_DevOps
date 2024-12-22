#!/bin/bash

LOG_FILE="/var/log/request_manager.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG_FILE
}

send_request() {
    local server="$1"
    local url="http://$server"

    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" -eq 200 ]; then
        log_message "Server $server responded with status 200 (OK)."
    else
        log_message "Warning: Server $server did not respond correctly (status $response)."
    fi
}

make_requests() {
    while true; do
    
        send_request "localhost:80/compute" &   
    
        
        sleep $((RANDOM % 6 + 5))
    done
}

make_requests
