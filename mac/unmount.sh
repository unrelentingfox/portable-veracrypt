#!/bin/bash
# Quick unmount script for VeraCrypt encrypted volume (macOS)

set -e

# Constants
MOUNT_POINT="/Volumes/vault"

# Load constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if VeraCrypt is installed (brew version only)
VERACRYPT_PATH=""
if [ -f "/opt/homebrew/bin/veracrypt" ]; then
    VERACRYPT_PATH="/opt/homebrew/bin/veracrypt"
elif [ -f "/usr/local/bin/veracrypt" ]; then
    VERACRYPT_PATH="/usr/local/bin/veracrypt"
else
    echo "Error: VeraCrypt not found. Please install:"
    echo "  brew install --cask veracrypt"
    exit 1
fi

# Find the device this script is running from
DEVICE=$(df "$SCRIPT_DIR" | tail -1 | awk '{print $1}' | sed 's/s[0-9]*$//')
ENCRYPTED_PARTITION="${DEVICE}s4"

echo "Unmounting: $ENCRYPTED_PARTITION"

if ! "$VERACRYPT_PATH" --text --dismount "$ENCRYPTED_PARTITION"; then
    echo "Error: Failed to unmount encrypted volume"
    exit 1
fi

# Clean up empty mount directory
sudo rmdir "$MOUNT_POINT" 2>/dev/null || true

echo "Encrypted volume unmounted"
