#!/bin/bash
# Quick mount script for VeraCrypt encrypted volume (macOS)
# Usage: ./mount.sh [r|w]  (r=ReadOnly, w=ReadWrite, default=ReadOnly)

set -e

# Constants
MOUNT_POINT="/Volumes/vault"

# Parse arguments
MODE="${1:-r}"
if [[ "$MODE" != "r" && "$MODE" != "w" ]]; then
    echo "Usage: $0 [r|w]"
    echo "  r = ReadOnly (default)"
    echo "  w = ReadWrite"
    exit 1
fi

# Set mount options
if [ "$MODE" = "r" ]; then
    MOUNT_OPTIONS="--mount-options=ro"
    MODE_TEXT="ReadOnly"
else
    MOUNT_OPTIONS=""
    MODE_TEXT="ReadWrite"
fi

# Load constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if VeraCrypt is installed (FUSE-T version only)
VERACRYPT_PATH=""
if [ -f "/opt/homebrew/bin/veracrypt" ]; then
    VERACRYPT_PATH="/opt/homebrew/bin/veracrypt"
elif [ -f "/usr/local/bin/veracrypt" ]; then
    VERACRYPT_PATH="/usr/local/bin/veracrypt"
else
    echo "Error: VeraCrypt FUSE-T version not found. Please install:"
    echo "  brew install --cask veracrypt-fuse-t"
    exit 1
fi

# Check if FUSE-T is installed
if ! brew list fuse-t >/dev/null 2>&1; then
    echo "Error: FUSE-T not installed. Please install FUSE-T first:"
    echo "  brew install --cask fuse-t"
    exit 1
fi

# Find the device this script is running from
DEVICE=$(df "$SCRIPT_DIR" | tail -1 | awk '{print $1}' | sed 's/s[0-9]*$//')
ENCRYPTED_PARTITION="${DEVICE}s4"

if [ ! -e "$ENCRYPTED_PARTITION" ]; then
    echo "Error: Encrypted partition $ENCRYPTED_PARTITION not found"
    exit 1
fi

echo "Found drive: $DEVICE"
echo "Encrypted partition: $ENCRYPTED_PARTITION"
echo "Mount mode: $MODE_TEXT"

# Check if already mounted
if mount | grep -q "$MOUNT_POINT"; then
    echo "Error: $MOUNT_POINT is already mounted"
    exit 1
fi

sudo mkdir -p "$MOUNT_POINT"
if ! "$VERACRYPT_PATH" --text --mount "$ENCRYPTED_PARTITION" "$MOUNT_POINT" $MOUNT_OPTIONS; then
    echo "Error: Failed to mount encrypted volume"
    sudo rmdir "$MOUNT_POINT" 2>/dev/null
    exit 1
fi

echo "Encrypted volume mounted at $MOUNT_POINT ($MODE_TEXT)"
