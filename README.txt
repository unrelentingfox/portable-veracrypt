VeraCrypt Portable Drive Setup
==============================

This drive contains:
1. UBUNTU LIVE (6.3GB) - Bootable Ubuntu 24.04.3 LTS live system
2. PUBLIC partition (10GB) - VeraCrypt portable apps for all platforms  
3. ENCRYPTED volume (916GB) - VeraCrypt encrypted storage (/dev/sdb4)

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

Using VeraCrypt in Ubuntu Live:
------------------------------
Option 1 - Install from repos:
- Open Terminal: Ctrl+Alt+T
- Run: sudo apt update && sudo apt install veracrypt
- Launch: Applications → Accessories → VeraCrypt

Option 2 - Use portable apps:
- Open Files app, navigate to this PUBLIC partition
- Go to VeraCrypt folder
- Run: chmod +x VeraCrypt_1.26.24_Linux.AppImage

MOUNTING ENCRYPTED VOLUME - All Platforms:
==========================================

Windows:
--------
1. Run VeraCrypt_1.26.24_Windows.exe from PUBLIC partition
2. Select an available drive letter (e.g., Z:)
3. Click "Select Device" → choose this USB drive → select the large partition
4. Click "Mount"
5. Enter your password
6. Access encrypted files at Z:\ drive

To Unmount:
- Select the mounted drive in VeraCrypt
- Click "Dismount"

macOS:
------
1. Open VeraCrypt_1.26.24_macOS.dmg from PUBLIC partition
2. Install or run VeraCrypt
3. Select a slot (1-64)
4. Click "Select Device" → choose this USB drive → select the large partition
5. Click "Mount"
6. Enter your password
7. Access encrypted files in Finder under "Volumes"

To Unmount:
- Select the mounted volume in VeraCrypt
- Click "Dismount"
- Or right-click volume in Finder → Eject

Linux (Ubuntu Live or other):
-----------------------------
1. Launch VeraCrypt (installed or portable AppImage)
2. Select a slot (1-64)
3. Click "Select Device" → choose /dev/sdb4 (or similar)
4. Click "Mount"
5. Enter your password
6. Choose mount point (e.g., /mnt/veracrypt1)
7. Access encrypted files at the mount point

To Unmount:
- Select the mounted volume in VeraCrypt
- Click "Dismount"
- Or use terminal: sudo umount /mnt/veracrypt1

Command Line (Linux/macOS):
---------------------------
Mount:
./VeraCrypt_1.26.24_Linux.AppImage --text --mount /dev/sdb4 /mnt/encrypted

Unmount:
./VeraCrypt_1.26.24_Linux.AppImage --text --dismount /dev/sdb4

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
