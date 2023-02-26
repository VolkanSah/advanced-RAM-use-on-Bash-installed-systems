# advanced-linux-server-tipps
### Free memory for Debian, Ubuntu, Arch, FreeBSD and other
Bash script that you can use in a cron job to clean the RAM if it's more than 90% used:

```bash
#!/bin/bash

# Set the threshold for free memory in bytes
THRESHOLD=$(( 90 * $(grep MemTotal /proc/meminfo | awk '{print $2}') / 100 ))

# Get the current amount of free memory
FREE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

# Check if free memory is below the threshold
if [ $FREE -lt $THRESHOLD ]; then
  echo "Cleaning RAM..."
  
  # Clear pagecache, dentries and inodes
  sync && echo 3 > /proc/sys/vm/drop_caches
  
  echo "RAM cleaned."
else
  echo "No need to clean RAM."
fi
```
### How the script works:
- The THRESHOLD variable is set to 90% of the total amount of RAM on the system, in bytes.
- The FREE variable is set to the current amount of free memory on the system, in bytes.
- If the amount of free memory is less than the threshold, the script clears the page cache, dentries, and inodes using the sync and drop_caches commands.
- The script outputs a message indicating whether or not RAM cleaning was performed.

You can save this script to a file (e.g. clean_ram.sh) and make it executable using the command 
```bash
chmod +x clean_ram.sh
```

Then, you can add it to a cron job to run at regular intervals, like this:

```bash
# Run the script every 5 minutes
*/5 * * * * /path/to/clean_ram.sh
```
This will run the script every 5 minutes and check if the amount of free memory is below the threshold. If it is, the script will clear the RAM cache to free up memory. This script should work on all of the Linux and BSD systems you listed.
