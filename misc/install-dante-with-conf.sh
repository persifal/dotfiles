#!/usr/bin/env bash


if id "socks" >/dev/null 2>&1; then
    echo 'socks user found'
else
    echo 'socks user not found. Please create it first.'
    exit 1
fi


if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

echo "Installing Dante SOCKS5 server..."
apt-get update
apt-get install -y dante-server

# Backup existing config
if [ -f /etc/dante.conf ]; then
    mv /etc/dante.conf /etc/dante.conf.backup
fi

# Config
cat > /etc/dante.conf << 'EOL'
logoutput: syslog
user.unprivileged: socks

internal: 0.0.0.0 port=1080
external: wg0

method: none

# Client rules
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

# SOCKS rules
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
EOL

systemctl enable danted
systemctl restart danted

# Check
if systemctl is-active --quiet danted; then
    echo "SOCKS5 proxy server is running on port 1080"
    echo "Current status:"
    systemctl status danted
else
    echo "Failed to start SOCKS5 proxy server"
    exit 1
fi

