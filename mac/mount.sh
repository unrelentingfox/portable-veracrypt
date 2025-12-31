#!/bin/bash
# Quick mount script for VeraCrypt encrypted volume (macOS)
# Usage: ./mount.sh [r|w]  (r=ReadOnly, w=ReadWrite, default=ReadOnly)

set -e

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
source "$SCRIPT_DIR/../constants.sh"

# Check if VeraCrypt is installed
VERACRYPT_PATH="/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt"
if [ ! -f "$VERACRYPT_PATH" ]; then
    echo "Error: VeraCrypt not found. Please install from ../VeraCrypt_1.26.24_macOS.dmg"
    exit 1
fi

# Check and install macFUSE if needed
if ! command -v mount_osxfuse &> /dev/null && ! command -v mount_macfuse &> /dev/null; then
    echo "Error: macFUSE not installed. Please install macFUSE first:"
    echo "  brew install --cask macfuse"
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
