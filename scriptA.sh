#!/bin/bash

LOG_FILE="/var/log/container_manager.log"
DOCKER_IMAGE="diana089/http_server:latest"
CPU_THRESHOLD_HIGH_SRV1=45.0
CPU_THRESHOLD_HIGH_SRV2=27.0
CPU_THRESHOLD_LOW=1.0
CHECK_INTERVAL_SECONDS=30

trap "exit" INT TERM
trap "kill 0" EXIT

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

fetch_cpu_usage() {
    docker stats --no-stream --format "{{.Name}} {{.CPUPerc}}" | grep "$1" | awk '{print $2}' | sed 's/%//' || echo "0"
}

assign_cpu_core() {
    case $1 in
        srv1) echo "0" ;;
        srv2) echo "1" ;;
        srv3) echo "2" ;;
        *) echo "0" ;;
    esac
}

launch_container() {
    local container_id=$1
    local cpu_core=$2

    if docker ps --format "{{.Names}}" | grep -q "^$container_id$"; then
        log_message "Container $container_id already exists. Removing it..."
        docker rm -f "$container_id" >/dev/null 2>&1
    fi

    log_message "Launching container $container_id on CPU core #$cpu_core..."
    docker run --name "$container_id" --cpuset-cpus="$cpu_core" --network bridge -d "$DOCKER_IMAGE"

    if docker ps --format "{{.Names}}" | grep -q "^$container_id$"; then
        log_message "Container $container_id launched successfully."
    else
        log_message "Error: Failed to start container $container_id."
    fi
}

update_all_containers() {
    log_message "Checking for new Docker image updates..."

    pull_status=$(docker pull "$DOCKER_IMAGE" | grep "Downloaded newer image")
    if [ -n "$pull_status" ]; then
        log_message "New Docker image detected. Updating all active containers..."
        active_containers=("srv1" "srv2" "srv3")

        for container in "${active_containers[@]}"; do
            if docker ps --format "{{.Names}}" | grep -q "^$container$"; then
                available_containers=$(docker ps --format "{{.Names}}" | grep -E "^srv" | wc -l)
                if (( available_containers > 1 )); then
                    updated_container="${container}_updated"
                    launch_container "$updated_container" "$(assign_cpu_core "$container")"
                    docker kill "$container" >/dev/null 2>&1
                    docker rm "$container" >/dev/null 2>&1
                    docker rename "$updated_container" "$container" >/dev/null 2>&1
                    log_message "Container $container successfully updated to the latest image."
                else
                    log_message "Skipping update for $container to ensure at least one container remains available."
                fi
            fi
        done
    else
        log_message "Docker image is up to date. No updates required."
    fi
}

monitor_and_manage() {
    while true; do
        for container_id in srv3 srv2; do
            if docker ps --format "{{.Names}}" | grep -q "$container_id"; then
                cpu_usage=$(fetch_cpu_usage "$container_id")
                if (( $(echo "$cpu_usage < $CPU_THRESHOLD_LOW" | bc -l) )); then
                    log_message "Container $container_id is idle. Stopping and removing..."
                    docker kill "$container_id" >/dev/null 2>&1
                    docker rm "$container_id" >/dev/null 2>&1
                fi
            fi
        done

        if docker ps --format "{{.Names}}" | grep -q "srv1"; then
            srv1_cpu_usage=$(fetch_cpu_usage "srv1")
            if (( $(echo "$srv1_cpu_usage > $CPU_THRESHOLD_HIGH_SRV1" | bc -l) )); then
                log_message "Container srv1 is under high load. Starting srv2..."
                if ! docker ps --format "{{.Names}}" | grep -q "srv2"; then
                    launch_container "srv2" 1
                fi
            fi
        else
            log_message "Container srv1 is not running. Starting it on CPU core #0."
            launch_container "srv1" 0
        fi
	if docker ps --format "{{.Names}}" | grep -q "srv2"; then
            srv2_cpu_usage=$(fetch_cpu_usage "srv2")
            if (( $(echo "$srv2_cpu_usage > $CPU_THRESHOLD_HIGH_SRV2" | bc -l) )); then
                log_message "Container srv2 is under high load. Starting srv3..."
                if ! docker ps --format "{{.Names}}" | grep -q "srv3"; then
                    launch_container "srv3" 2
                fi
            fi
        fi

        update_all_containers
        sleep "$CHECK_INTERVAL_SECONDS"
    done
}

monitor_and_manage
