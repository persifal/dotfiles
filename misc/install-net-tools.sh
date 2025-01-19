#!/usr/bin/env bash

if dpkg -l | grep -q "^ii.*net-tools"; then
    echo "net-tools is already installed"
else
    echo "net-tools is not installed"
    echo "Installing net-tools..."
    if [ "$EUID" -ne 0 ]; then
        echo "Please run with sudo privileges"
        exit 1
    fi
    
    apt-get update -y
    apt-get install -y net-tools
    
    if dpkg -l | grep -q "^ii.*net-tools"; then
        echo "net-tools installed successfully"
    else
        echo "Installation failed"
        exit 1
    fi
fi

