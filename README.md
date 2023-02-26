# Advanced RAM use on all Bash installed systems
## Advanced Free memory
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


####################################
## Advanced ZRAM use
Zram is a Linux kernel module that allows for compressed RAM-based swap space. Using Zram can improve performance on systems with limited RAM, as it can reduce the amount of data that needs to be written to disk.

### Check if Zram is already installed.
Run the following command to check if the zram module is already installed:

```bash
lsmod | grep zram
```
If the output shows the zram module, then it's already installed. If not, you can install it using the appropriate package manager for your distribution.
### Create a Zram device.
Once Zram is installed, you can create a Zram device using the following command:

```bash
sudo modprobe zram num_devices=1
```
This will create one Zram device with default parameters. You can specify a different number of devices or customize other parameters as needed.

Configure the Zram device.
After the Zram device is created, you need to configure it by setting the size of the swap space and enabling compression. Here's an example configuration that sets the size of the swap space to 1 GB and enables compression:

```bash
$ sudo sysctl -w vm.swappiness=10
$ sudo zramctl -f -s 1g -t 2
```

This sets the vm.swappiness value to 10 (which determines how aggressively the kernel swaps out memory to disk), creates a Zram device with a 1 GB swap size, and enables LZ4 compression with a compression ratio of 2:1.

Mount the Zram device.
Finally, you need to mount the Zram device as swap space using the following command:

```bash
$ sudo mkswap /dev/zram0
$ sudo swapon /dev/zram0
```

This formats the Zram device as swap space and activates it. You can check if the Zram device is being used as swap space by running the following command:

```bash
$ swapon -s
```bash
```
This will show a list of all the active swap devices, including the Zram device if it's being used.
-- You can automate this process by adding the necessary commands to a Bash script and running it as a cron job or a systemd service --




This Bash scripts  should work on any Linux system that has Bash installed, as well as other Unix-like systems that have Bash installed.


