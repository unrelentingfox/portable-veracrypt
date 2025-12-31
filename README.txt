VeraCrypt Portable Drive Setup
==============================

This drive contains:
1. UBUNTU LIVE (6.3GB) - Bootable Ubuntu 24.04.3 LTS live system
2. PUBLIC partition (10GB) - VeraCrypt portable apps for all platforms  
3. ENCRYPTED volume (916GB) - VeraCrypt encrypted storage (/dev/sda4)

Directory Structure:
-------------------
VeraCrypt/
├── constants.sh (shared configuration)
├── README.txt (this file)
├── linux/ - Linux scripts and AppImage
├── mac/ - macOS scripts and DMG installer
└── windows/ - Windows executable

How to Boot Ubuntu Live:
-----------------------
1. Insert this USB drive into target computer
2. Restart computer and enter BIOS/UEFI:
   - Press F2, F12, Del, or Esc during startup (varies by manufacturer)
   - Or hold Shift while clicking "Restart" in Windows
3. Enable "Boot from USB" or change boot priority
4. Save and exit BIOS
5. Select this USB drive from boot menu
6. Choose "Try Ubuntu" (live mode - no installation)
7. Ubuntu will run from RAM (changes not saved on reboot)

Using VeraCrypt Scripts:
========================

Linux (Ubuntu Live or other):
-----------------------------
1. Navigate to VeraCrypt/linux/ folder
2. Run: ./mount.sh (ReadOnly) or ./mount.sh w (ReadWrite)
3. Enter your password when prompted
4. Access encrypted files at /mnt/vault
5. Run: ./unmount.sh when finished

macOS:
------
1. Install VeraCrypt: Double-click VeraCrypt/mac/VeraCrypt_1.26.24_macOS.dmg
2. Install macFUSE: brew install --cask macfuse
3. Navigate to VeraCrypt/mac/ folder
4. Run: ./mount.sh (ReadOnly) or ./mount.sh w (ReadWrite)
5. Enter your password when prompted
6. Access encrypted files at /mnt/vault
7. Run: ./unmount.sh when finished

MOUNTING ENCRYPTED VOLUME - All Platforms:
==========================================

Windows:
--------
1. Run VeraCrypt/windows/VeraCrypt_1.26.24_Windows.exe
2. Select an available drive letter (e.g., Z:)
3. Click "Select Device" → choose this USB drive → select the large partition
4. Click "Mount"
5. Enter your password
6. Access encrypted files at Z:\ drive

To Unmount:
- Select the mounted drive in VeraCrypt
- Click "Dismount"

Troubleshooting Mount Issues:
----------------------------
- Ensure USB drive is properly connected
- Try different drive letters/slots
- Check password is correct
- On Linux: ensure mount point exists (mkdir /mnt/encrypted)
- On macOS: may need to allow VeraCrypt in Security preferences
- If "device busy": ensure no files are open from encrypted volume

Documentation:
-------------
Official VeraCrypt Documentation: https://veracrypt.io/en/Documentation.html
User Guide: https://veracrypt.io/en/Beginner%27s%20Tutorial.html
Ubuntu Live USB Guide: https://ubuntu.com/tutorials/try-ubuntu-before-you-install

Security Notes:
--------------
- Ubuntu live system runs in RAM (changes not persistent)
- PUBLIC partition is unencrypted (VeraCrypt software only)
- All sensitive data should be stored in the encrypted volume
- Always dismount encrypted volume before removing USB drive
- No mobile support - use desktop/laptop computers only

Drive Layout:
------------
/dev/sdb1: Ubuntu Live System (5.9GB)
/dev/sdb2: EFI Boot Partition (5MB)
/dev/sdb3: PUBLIC - VeraCrypt Apps (9.3GB)
/dev/sdb4: ENCRYPTED Volume (916GB) ← Your encrypted storage

Created: December 31, 2025
VeraCrypt Version: 1.26.24
Ubuntu Version: 24.04.3 LTS
Encryption: AES with SHA-512 hash, exFAT filesystem
