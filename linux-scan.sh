#!/bin/bash
#
# Welcome to a ClamAV 1.3.0 shell script for GNU/Linux
# Written by Camina Shell 2024-02 https://github.com/caminashell
# Tested on Debian 12.5 6.1.0-17-amd64 [2024-02-13 08:43:42]

# Download Clam Anti Virus for free from: https://www.clamav.net

# I share my scripts for research, education, and public support.
# By using this script you accept that I (caminashell) am not responsible for
# any damage or corruption to your property.

# All dates are in ISO 8601 format: YYYY-MM-DD

# It is recommended to run this script as admin.
# Careful: Testing this script can get you rate limited on CDN for 24hrs.
#          Advised to echo the execution: $AV/freshclam
#          or better; set up a mirror as suggested by CLamAV.

# Setting up the script
CLICOLOR=1
GREY='\033[0;30m'
PURPLE='\033[0;35m'
BLUE='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
ITALIC='\e[2m'

BLINK='\e[1m\e[5m'
NC='\033[0m' # No Color / Reset
CLS='\e[3J'

# This assumes that you have installed ClamAV to the default from the installer.
AV=/usr/local/bin

# This is Basically your home folder documents location.
DIR=~/Documents

# This is creating a timestamp for the scan.
STAMP=$(date +%Y%m%d-%H%M%S%N)

# A little note for the user, just in case. Let's hope they (can) read!
echo -e "$BOLD$PURPLE\nNOTE: This script should be run as superuser.$NC\n"

# This execution attempts to update the viri databases. It will fail if it cannot access the remote host.

# --- NOTES ---
# ERROR: Can't open/parse the config file /usr/local/etc/freshclam.conf
# Creating missing database directory: /usr/local/share/clamav

# ERROR: Failed to get information about user "clamav".
# Create the "clamav" user account for freshclam to use, or set the DatabaseOwner config option in freshclam.conf to a different user.
# For more information, see https://docs.clamav.net/manual/Installing/Installing-from-source-Unix.html
# ERROR: Initialization error!

# ^^^ Remember to check config.
# config files in /usr/local/etc/
# db gets wriiten to /usr/local/share/clamav

if getent group clamav | grep -qw "clamav"; then
  echo -e "[$GREEN✓$NC] ClamAV user exists. Continuing to update check...\n"
    $AV/freshclam
  # --- TESTING ---
  # gpasswd --delete clamav clamav
  # userdel clamav

  # --- NOTES ---
  # WARNING: Can't download main.cvd from https://database.clamav.net/main.cvd
  # WARNING: FreshClam received error code 429 from the ClamAV Content Delivery Network (CDN).
  # This means that you have been rate limited by the CDN.
  #  1. Run FreshClam no more than once an hour to check for updates.
  #     FreshClam should check DNS first to see if an update is needed.
  #  2. If you have more than 10 hosts on your network attempting to download,
  #     it is recommended that you set up a private mirror on your network using
  #     cvdupdate (https://pypi.org/project/cvdupdate/) to save bandwidth on the
  #     CDN and your own network.
  #  3. Please do not open a ticket asking for an exemption from the rate limit,
  #     it will not be granted.
  # WARNING: You are on cool-down until after: 2024-02-14 07:55:10
else
  echo -e "$RED!!!$NC ClamAV user not found. Creating user..."
    groupadd clamav
  echo -e "[$GREEN✓$NC] Group created."
    useradd -g clamav -s /bin/false -c "Clam Antivirus" clamav
  echo -e "[$GREEN✓$NC] User created."
    passwd -l clamav >& /dev/null
  echo -e "[$GREEN✓$NC] User account locked."
    chown clamav:root /usr/local/share/clamav
  echo -e "[$GREEN✓$NC] User permission set. Continuing to update check...\n"
    $AV/freshclam
fi

# This will ask you to enter a full path as a target to can.
# It can be a directory or file, but it should be a full path.
# Examples:
# /
# /some/path/to/a/folder
# ~/some/path/to/a\ single/file.txt
echo -e "Enter FULL path to scan [do not use quotes]:\n"
read SCAN

# This just tells you the timestamp as a Scan ID.
echo -e "\nScan ID: $STAMP\n"

# Creating some subdirectories for scan.
mkdir -p $DIR/ClamAV/$STAMP
mkdir -p $DIR/ClamAV/$STAMP/infected

# Setting up and testing the log file. If the scan fails, you should see only "Log File Created."
DIR=$DIR/ClamAV
echo. 2>$DIR/$STAMP/report.log
echo "Log File Created." > "$DIR/$STAMP/report.log"

# If you want to test the command line below without executing it, put "echo " at the beginning of the line.
echo "$AV/clamscan" -a -r -l="$DIR/$STAMP/report.log" --exclude-dir="$DIR" --bell --copy="$DIR/$STAMP/infected" "$SCAN"

# An additional summary to the user...
echo -e "------------------------------------\n"
echo -e "[$GREEN✓$NC] Scan report file saved to: $BLUE$DIR/$STAMP/report.log$NC"
echo -e "[$GREEN✓$NC] Infected file/s COPIED to: $BLUE$DIR/$STAMP/infected$NC\n"

# ... and because some people just aren't savvy...
echo -e "$BLINK$RED!!! CAUTION !!!$NC DO NOT ATTEMPT TO OPEN OR EXECUTE ANY INFECTED FILES.$NC"
echo -e "                 YOU RISK INFECTING OR DAMAGING YOUR SYSTEM.\n"
echo -e "Some results can be false positive, so seek further advice and guidance."
echo -e "If you are worried, back up your sensitive data. Be smart.\n"

# Thank you for checking out my little script for ClamAV - the best FREE + OPEN SOURCE cross-platform Anti-virus.
# I hope it helps you deter any bad news on your system, or at least provide some education.
