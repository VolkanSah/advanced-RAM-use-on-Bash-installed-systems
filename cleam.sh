#!/bin/bash

# Set the threshold for free memory in bytes (90% of total RAM)
THRESHOLD=$(( 90 * $(grep MemTotal /proc/meminfo | awk '{print $2}') / 100 ))

# Get current free memory
FREE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

# Clean RAM if free memory is below threshold
if [ $FREE -lt $THRESHOLD ]; then
  echo "Cleaning RAM..."
  sync && echo 3 > /proc/sys/vm/drop_caches
  echo "RAM cleaned."
else
  echo "No need to clean RAM."
fi
