#!/bin/bash

LOG_FILE="/var/log/auto_deploy.log"
IMAGE_NAME="diana089/http_server"
CONTAINERS=("srv1" "srv2" "srv3")

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG_FILE
}

check_new_image() {
    log_message "Checking for newer image on the server..."
    pullResult=$(docker pull $IMAGE_NAME | grep "Downloaded newer image")
    if [ -n "$pullResult" ]; then
        log_message "Newer image downloaded: $pullResult"
        return 0
    else
        log_message "Image is up to date."
        return 1
    fi
}

update_container() {
    local container=$1
    if docker ps --format "{{.Names}}" | grep -q "^$container$"; then
        log_message "Restarting $container:"
        log_message "  Sending SIGINT to $container..."
        docker kill --signal=SIGINT $container
        log_message "  Waiting for $container to terminate..."
        docker wait $container
    else
        log_message "$container is not running."
    fi

    log_message "Starting new server for $container..."
    docker run --name $container --rm -d $IMAGE_NAME
    log_message "$container has been updated and restarted."
}

main() {
    date | tee -a $LOG_FILE
    if check_new_image; then
        for container in "${CONTAINERS[@]}"; do
            update_container $container
        done
        log_message "All containers updated successfully."
    else
        log_message "No updates were performed."
    fi
}

main
