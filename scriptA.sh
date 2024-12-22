#!/bin/bash

LOG_FILE="/var/log/container_manager.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a $LOG_FILE
}

start_container() {
    local container_name="$1"
    local cpu_core="$2"

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

stop_container() {
    local container_name="$1"

    if docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null | grep -q "true"; then
        log_message "Stopping container $container_name due to inactivity..."
        docker stop "$container_name" >/dev/null 2>&1
        docker rm "$container_name" >/dev/null 2>&1
    fi
}

check_cpu_usage() {
    local container_name="$1"
    local usage_threshold="$2"

    cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container_name" | tr -d '%')
    cpu_usage=${cpu_usage%%.*}  

    if [ "$cpu_usage" -ge "$usage_threshold" ]; then
        echo "busy"
    else
        echo "idle"
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
    start_container "srv1" 0

    while true; do
	if docker ps --format "{{.Names}}" | grep -q "srv3"; then
            if [ "$(check_cpu_usage srv3 10)" == "idle" ]; then
                stop_container "srv3"
            fi
        fi
        
        update_image
        if [ $? -eq 0 ]; then
            log_message "Restarting containers after image update..."
            start_container "srv1" 0
        fi

      
        if [ "$(check_cpu_usage srv1 50)" == "busy" ]; then
            start_container "srv2" 1
        elif docker ps --format "{{.Names}}" | grep -q "srv2"; then
            if [ "$(check_cpu_usage srv2 50)" == "busy" ]; then
                start_container "srv3" 2
            elif [ "$(check_cpu_usage srv2 10)" == "idle" ]; then
                stop_container "srv2"
            fi
        fi

        sleep 30
    done
}

manage_containers
