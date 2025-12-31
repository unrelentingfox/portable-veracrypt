#!/bin/bash
# Quick unmount script for VeraCrypt encrypted volume (macOS)

set -e

# Load constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../constants.sh"

# Check if VeraCrypt is installed
VERACRYPT_PATH="/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt"
if [ ! -f "$VERACRYPT_PATH" ]; then
    echo "Error: VeraCrypt not found. Please install from $SCRIPT_DIR/VeraCrypt_1.26.24_macOS.dmg"
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
