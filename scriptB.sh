#!/bin/bash

LOG_FILE="/var/log/request_manager.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG_FILE
}

send_request() {
    local server="$1"
    local url="http://$server"

    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "error")
    if [ "$response" == "200" ]; then
        log_message "Server $server responded with status 200 (OK)."
    elif [ "$response" == "error" ]; then
        log_message "Error: Could not connect to server $server."
    else
        log_message "Warning: Server $server did not respond correctly (status $response)."
    fi
}
make_requests() {
    local server="localhost:80/compute"  
    while true; do
        send_request "$server" &
        sleep $((RANDOM % 3 + 4))
    done
}


if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

make_requests
