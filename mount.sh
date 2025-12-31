#!/bin/bash
# Quick mount script for VeraCrypt encrypted volume
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
source "$SCRIPT_DIR/constants.sh"

# Check and install FUSE if needed
if ! command -v fusermount &> /dev/null; then
    echo "Installing FUSE..."
    sudo apt update && sudo apt install -y fuse libfuse2
fi

# Find the device this script is running from
DEVICE=$(df "$SCRIPT_DIR" | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')
ENCRYPTED_PARTITION="${DEVICE}4"

if [ ! -e "$ENCRYPTED_PARTITION" ]; then
    echo "Error: Encrypted partition $ENCRYPTED_PARTITION not found"
    exit 1
fi

echo "Found drive: $DEVICE"
echo "Encrypted partition: $ENCRYPTED_PARTITION"
echo "Mount mode: $MODE_TEXT"

# Check if already mounted
if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
    echo "Error: $MOUNT_POINT is already mounted"
    exit 1
fi

sudo mkdir -p "$MOUNT_POINT"
if ! ./VeraCrypt_1.26.24_Linux.AppImage --text --mount "$ENCRYPTED_PARTITION" "$MOUNT_POINT" $MOUNT_OPTIONS; then
    echo "Error: Failed to mount encrypted volume"
    sudo rmdir "$MOUNT_POINT" 2>/dev/null
    exit 1
fi

echo "Encrypted volume mounted at $MOUNT_POINT ($MODE_TEXT)"
