#!/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Remove AsusFnKeysDaemon
if [[ -d /usr/bin/AsusFnKeysDaemon ]]; then
  sudo launchctl unload /Library/LaunchAgents/com.hieplpvip.AsusFnKeysDaemon.plist 2>/dev/null
  sudo pkill -f AsusFnKeysDaemon
  sudo rm /usr/bin/AsusFnKeysDaemon 2>/dev/null
  sudo rm /Library/LaunchAgents/com.hieplpvip.AsusFnKeysDaemon.plist 2>/dev/null
fi

# Remove old AsusSMCDaemon
if [[ -d /usr/bin/AsusSMCDaemon ]]; then
  sudo launchctl unload /Library/LaunchAgents/com.hieplpvip.AsusSMCDaemon.plist 2>/dev/null
  sudo rm /usr/bin/AsusSMCDaemon 2>/dev/null
fi

sudo mkdir -p /usr/local/bin/
sudo chmod -R 755 /usr/local/bin/
sudo cp $DIR/AsusSMCDaemon /usr/local/bin/
sudo chmod 755 /usr/local/bin/AsusSMCDaemon
sudo chown root:wheel /usr/local/bin/AsusSMCDaemon
sudo xattr -d com.apple.quarantine /usr/local/bin/AsusSMCDaemon 2>/dev/null

sudo cp $DIR/com.hieplpvip.AsusSMCDaemon.plist /Library/LaunchAgents
sudo chmod 644 /Library/LaunchAgents/com.hieplpvip.AsusSMCDaemon.plist
sudo chown root:wheel /Library/LaunchAgents/com.hieplpvip.AsusSMCDaemon.plist
sudo xattr -d com.apple.quarantine /Library/LaunchAgents/com.hieplpvip.AsusSMCDaemon.plist 2>/dev/null

sudo launchctl load /Library/LaunchAgents/com.hieplpvip.AsusSMCDaemon.plist
