#!/bin/bash
# Quick unmount script for VeraCrypt encrypted volume

set -e

# Load constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../constants.sh"

# Find the device this script is running from
DEVICE=$(df "$SCRIPT_DIR" | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')
ENCRYPTED_PARTITION="${DEVICE}4"

echo "Unmounting: $ENCRYPTED_PARTITION"

if ! ./VeraCrypt_1.26.24_Linux.AppImage --text --dismount "$ENCRYPTED_PARTITION"; then
    echo "Error: Failed to unmount encrypted volume"
    exit 1
fi

# Clean up empty mount directory
sudo rmdir "$MOUNT_POINT" 2>/dev/null || true

echo "Encrypted volume unmounted"
