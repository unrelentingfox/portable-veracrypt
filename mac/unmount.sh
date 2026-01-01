#!/bin/bash
# Quick unmount script for VeraCrypt encrypted volume (macOS)

set -e

# Constants
MOUNT_POINT="/Volumes/vault"

# Load constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if VeraCrypt is available
if ! command -v veracrypt >/dev/null 2>&1; then
    echo "Error: VeraCrypt not found. Please install:"
    echo "  brew install --cask veracrypt-fuse-t"
    exit 1
fi

VERACRYPT_PATH="$(command -v veracrypt)"

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
