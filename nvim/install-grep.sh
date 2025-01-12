#!/usr/bin/env bash

echo "Check for grep engine..."
if [ "$(uname)" == "Darwin" ]; then
    brew install ripgrep
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ $(dpkg-query -W -f='${Status}' nano 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "Installing ripgrep..."
        apt-get install ripgrep
    fi
fi

