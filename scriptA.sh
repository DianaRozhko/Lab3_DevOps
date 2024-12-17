#!/bin/bash

LOG_FILE="/var/log/container_manager.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG_FILE
}

start_container() {
    container_name="$1"
    cpu_core="$2"

    if docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null | grep -q "true"; then
        log_message "Container $container_name is already running. No action needed."
        return
    fi

    if docker ps -a --format "{{.Names}}" | grep -q "^$container_name$"; then
        log_message "Container $container_name exists but is not running. Removing it..."
        docker rm -f "$container_name" >/dev/null 2>&1
    fi

    log_message "Starting container $container_name on core CPU #$cpu_core..."
    docker run --name "$container_name" --cpuset-cpus="$cpu_core" --network bridge -d diana089/http_server

    if docker ps --format "{{.Names}}" | grep -q "^$container_name$"; then
        log_message "Container $container_name started successfully."
    else
        log_message "Error: Failed to start container $container_name."
    fi
}

update_image() {
    log_message "Checking for a newer image on the Docker Hub..."

    pull_result=$(docker pull diana089/http_server | grep "Downloaded newer image")
    if [ -n "$pull_result" ]; then
        log_message "New image detected -----> updating containers..."
        return 0
    else
        log_message "Image is up to date. No updates needed."
        return 1
    fi
}

manage_containers() {
    while true; do
        update_image
        if [ $? -eq 0 ]; then
            log_message "Restarting containers after image update..."
            start_container "srv1" 0
        fi

        start_container "srv1" 0
        sleep 300
    done
}

manage_containers
