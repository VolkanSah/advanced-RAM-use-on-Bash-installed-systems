
# Advanced RAM use on Bash-installed Systems (2024)

This guide provides scripts and tips to optimize RAM usage on systems with Bash installed.

## Table of Contents
- [Free Memory Management](#free-memory-management)
  - [Clean RAM Script](#clean-ram-script)
- [ZRAM Usage](#zram-usage)
  - [Check ZRAM Installation](#check-zram-installation)
  - [Create and Configure ZRAM](#create-and-configure-zram)
  - [Mount ZRAM as Swap](#mount-zram-as-swap)
  - [ZRAM Swap as Percentage of RAM](#zram-swap-as-percentage-of-ram)
- [Additional Tips](#additional-tips)
  - [Lightweight Window Manager](#lightweight-window-manager)
  - [Disable Unnecessary Services](#disable-unnecessary-services)
  - [Close Unused Applications](#close-unused-applications)
  - [Prioritize Processes](#prioritize-processes)
  - [Clear Disk Cache](#clear-disk-cache)
  - [Set Process Limits](#set-process-limits)

## Free Memory Management

### Clean RAM Script
Use this script in a cron job to clean RAM if usage exceeds 90%.

```bash
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
```

Make the script executable and schedule it to run every 5 minutes:

```bash
chmod +x clean_ram.sh
crontab -e
```
Add the following line to the crontab:

```bash
*/5 * * * * /path/to/clean_ram.sh
```

## ZRAM Usage

### Check ZRAM Installation
Verify if ZRAM is installed:

```bash
lsmod | grep zram
```
If not installed, use your package manager to install it.

### Create and Configure ZRAM
Create a ZRAM device and set its size to 1 GB with compression:

```bash
sudo modprobe zram num_devices=1
sudo zramctl -f -s 1G -t 2
```
Set the swappiness value:

```bash
sudo sysctl -w vm.swappiness=10
```

### Mount ZRAM as Swap
Format and activate the ZRAM device as swap:

```bash
sudo mkswap /dev/zram0
sudo swapon /dev/zram0
````
Verify ZRAM usage:

```bash
sudo swapon -s
```

### ZRAM Swap as Percentage of RAM
Create ZRAM swap space as 25% of physical RAM:

```bash
sudo zramctl --find --size $(($(free | awk '/^Mem:/{print $2}') / 4)) --mkswap
sudo swapon /dev/zram0
```

## Additional Tips

### Lightweight Window Manager
Use lightweight window managers like Xfce, LXDE, or Openbox to reduce memory usage.

### Disable Unnecessary Services
Disable services to free up memory and reduce CPU usage:

```bash
sudo systemctl disable <service_name>
```

### Close Unused Applications
Use \`htop\` or \`top\` to monitor and close unused applications.

### Prioritize Processes
Adjust process priority with \`nice\`:

```bash
nice -n <priority> <command>
```

### Clear Disk Cache
Free up memory by clearing disk cache:

```bash
sudo sync
sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
```

### Set Process Limits
Use \`ulimit\` to set limits on system resources for processes:

```bash
ulimit -m <memory_limit>
ulimit -t <cpu_time_limit>
```

These tips help optimize and clean up RAM on Bash-installed systems, improving performance and stability.
### Credits
**Volkan Kücükbudak**
