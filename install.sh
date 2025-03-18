#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Get user input
read -p "Enter your username: " username
read -p "Enter the npipe-relay.exe directory path: " npipe_relay_dir

# Create the necessary directories
mkdir -p /etc/1password-ssh-agent/
mkdir -p /home/$username/.1password/

# Copy files to their destinations (not move)
cp 1password.service /etc/systemd/system/
cp agent-bridge.sh /etc/1password-ssh-agent/

# Replace placeholders in the service file
sed -i "s/<replace_me_with_username>/${username}/g" /etc/systemd/system/1password.service
sed -i "s|<replace_me_to_npipe_relay_exe_dir>|${npipe_relay_dir}|g" /etc/1password-ssh-agent/agent-bridge.sh

# Set correct permissions
chmod 644 /etc/systemd/system/1password.service
chmod 644 /etc/1password-ssh-agent/agent-bridge.sh
chown $username:$username /home/$username/.1password/

# Reload systemd
systemctl daemon-reload

# Enable and start the service
systemctl enable 1password
if ! systemctl start 1password; then
    echo "Failed to start 1password service"
    echo "Check status with: systemctl status 1password"
    exit 1
fi

# Verify service is running
if systemctl is-active --quiet 1password; then
    echo "1Password service has been installed and started successfully"
else
    echo "1Password service is not running"
    echo "Check status with: systemctl status 1password"
    exit 1
fi