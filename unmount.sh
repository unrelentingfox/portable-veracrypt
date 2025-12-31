#!/bin/bash
# Quick unmount script for VeraCrypt encrypted volume

./VeraCrypt_1.26.24_Linux.AppImage --text --dismount /dev/sdb4
echo "Encrypted volume unmounted"
