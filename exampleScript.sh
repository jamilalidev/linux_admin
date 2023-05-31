#!/bin/bash

# Function to handle SIGINT signal
sigint_handler() {
  echo "Received SIGINT signal. Stopping all processes..."
  for pid in "${pids[@]}"; do
    kill -SIGINT "$pid"  # Send SIGINT signal to each process
  done
}

# Function to handle SIGTERM signal
sigterm_handler() {
  echo "Received SIGTERM signal. Stopping all processes..."
  for pid in "${pids[@]}"; do
    kill -SIGTERM "$pid"  # Send SIGTERM signal to each process
  done
}

# Register signal handlers
trap sigint_handler SIGINT
trap sigterm_handler SIGTERM

# Function to start a process and redirect stdout and stderr to log files
start_process() {
  sleep "$1" &> "/tmp/process_$2.log"  # Redirect both stdout and stderr to a log file
  echo "Process $2 completed"
}

# Array to store process PIDs
pids=()

# Launch three processes in the background
echo "Launching processes..."
start_process 5 1 &  # Start process 1 and sleep for 5 seconds
pids+=($!)  # Store the PID of process 1

start_process 3 2 &  # Start process 2 and sleep for 3 seconds
pids+=($!)  # Store the PID of process 2

start_process 7 3 &  # Start process 3 and sleep for 7 seconds
pids+=($!)  # Store the PID of process 3

# Wait for all processes to complete
echo "Waiting for processes to finish..."
for pid in "${pids[@]}"; do
  wait "$pid"
done

echo "All processes completed."

