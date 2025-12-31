#!/bin/bash
# Quick mount script for VeraCrypt encrypted volume

# Check and install FUSE if needed
if ! command -v fusermount &> /dev/null; then
    echo "Installing FUSE..."
    sudo apt update && sudo apt install -y fuse libfuse2
fi

MOUNT_POINT="/mnt/dustin_vault"
sudo mkdir -p "$MOUNT_POINT"
./VeraCrypt_1.26.24_Linux.AppImage --text --mount /dev/sdb4 "$MOUNT_POINT"
echo "Encrypted volume mounted at $MOUNT_POINT"
