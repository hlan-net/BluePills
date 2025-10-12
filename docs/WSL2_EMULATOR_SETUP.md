# Running Android Emulator on WSL2

This guide explains how to run the Android emulator for BluePills development on WSL2 (Windows Subsystem for Linux 2).

## Prerequisites

- Windows 11 or Windows 10 with WSL2 enabled
- Android Studio installed on Windows
- Flutter development environment set up in WSL2

## Overview

Since WSL2 doesn't have direct access to the GPU for hardware acceleration, we have two main approaches:

1. **Use Windows-side Android Emulator (Recommended)**
2. **Connect to a Physical Device via ADB**

## Option 1: Use Windows Android Emulator (Recommended)

This approach runs the Android emulator on Windows and connects to it from WSL2.

### Step 1: Set up Android Studio on Windows

1. **Install Android Studio on Windows** (if not already installed)
   - Download from: https://developer.android.com/studio
   - Install to default location (usually `C:\Program Files\Android\Android Studio`)

2. **Create an Android Virtual Device (AVD)**
   - Open Android Studio on Windows
   - Go to `Tools` → `Device Manager`
   - Click `Create Device`
   - Select a device (e.g., Pixel 8)
   - Select a system image (e.g., Android 14 / API 34)
   - Name your AVD (e.g., "Pixel_8_API_34")
   - Click `Finish`

### Step 2: Configure ADB Bridge Between WSL2 and Windows

1. **Find your WSL2 IP address** (from WSL2 terminal):
   ```bash
   # Get WSL2 IP
   ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
   ```

2. **Find your Windows host IP** (from WSL2):
   ```bash
   # Get Windows host IP
   cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
   # Or
   ip route show | grep -i default | awk '{ print $3}'
   ```

3. **Install ADB tools on Windows** (if not already):
   - ADB comes with Android Studio
   - Default location: `C:\Users\<YourUsername>\AppData\Local\Android\Sdk\platform-tools`

4. **Set up ADB connection from WSL2 to Windows**:

   Add this to your `~/.bashrc` or `~/.zshrc` in WSL2:
   
   ```bash
   # ADB Bridge for WSL2
   export WSL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
   export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
   
   # Helper function to connect to Windows ADB
   function adb-connect() {
       adb kill-server 2>/dev/null
       adb -H $WSL_HOST -P 5037 start-server
       echo "Connected to Windows ADB server at $WSL_HOST:5037"
   }
   ```

5. **Source the updated config**:
   ```bash
   source ~/.bashrc
   # or
   source ~/.zshrc
   ```

### Step 3: Start the Emulator

1. **On Windows PowerShell or Command Prompt**:
   ```powershell
   # Navigate to emulator directory
   cd C:\Users\<YourUsername>\AppData\Local\Android\Sdk\emulator
   
   # List available AVDs
   .\emulator.exe -list-avds
   
   # Start the emulator
   .\emulator.exe -avd Pixel_8_API_34
   ```

   Or create a shortcut script `start-emulator.bat`:
   ```batch
   @echo off
   cd C:\Users\%USERNAME%\AppData\Local\Android\Sdk\emulator
   emulator.exe -avd Pixel_8_API_34
   ```

2. **Verify ADB server is running on Windows**:
   ```powershell
   # In PowerShell
   cd C:\Users\<YourUsername>\AppData\Local\Android\Sdk\platform-tools
   .\adb.exe devices
   ```

### Step 4: Connect from WSL2

1. **In your WSL2 terminal**:
   ```bash
   # Connect to Windows ADB server
   adb-connect
   
   # Verify connection
   adb devices
   # Should show:
   # List of devices attached
   # emulator-5554    device
   ```

2. **Run Flutter app**:
   ```bash
   cd /path/to/BluePills
   flutter devices
   # Should list the emulator
   
   flutter run
   ```

### Troubleshooting Windows Emulator Connection

#### ADB not found from WSL2
```bash
# Install ADB in WSL2
sudo apt update
sudo apt install adb
```

#### Can't connect to Windows ADB
```bash
# Kill and restart ADB on both sides
# On Windows:
adb.exe kill-server
adb.exe start-server

# On WSL2:
adb kill-server
export ADB_SERVER_SOCKET=tcp:$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):5037
adb devices
```

#### Emulator not showing in devices
```bash
# Check Windows firewall - ensure ADB port 5037 is allowed
# In Windows PowerShell (as Administrator):
New-NetFirewallRule -DisplayName "ADB" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5037
```

#### Connection reset issues
```bash
# Restart Windows ADB with network binding
# In Windows PowerShell:
cd C:\Users\<YourUsername>\AppData\Local\Android\Sdk\platform-tools
.\adb.exe kill-server
.\adb.exe -a -P 5037 start-server
```

## Option 2: Physical Android Device

Using a physical device is often simpler and provides better performance.

### Setup Steps

1. **Enable Developer Options on your Android device**:
   - Go to `Settings` → `About Phone`
   - Tap `Build Number` 7 times
   - Go back to `Settings` → `Developer Options`
   - Enable `USB Debugging`

2. **Connect via USB**:

   **USB Passthrough (Recommended for USB connection)**:
   
   Windows 11 supports USB passthrough to WSL2:
   
   ```powershell
   # In Windows PowerShell (as Administrator)
   # Install usbipd
   winget install --interactive --exact dorssel.usbipd-win
   
   # List USB devices
   usbipd list
   
   # Find your Android device (e.g., bus ID 3-2)
   # Attach it to WSL2
   usbipd bind --busid 3-2
   usbipd attach --wsl --busid 3-2
   ```
   
   ```bash
   # In WSL2
   # Verify device is connected
   lsusb
   adb devices
   ```

3. **Connect via WiFi** (Alternative):
   
   ```bash
   # First connect via USB, then:
   # On WSL2:
   adb tcpip 5555
   
   # Get device IP (on Android: Settings → About → Status → IP address)
   # Or from WSL2 while USB connected:
   adb shell ip addr show wlan0 | grep "inet\s" | awk '{print $2}' | cut -d/ -f1
   
   # Disconnect USB, then connect via WiFi:
   adb connect <DEVICE_IP>:5555
   
   # Verify connection
   adb devices
   ```

### Run on Physical Device

```bash
cd /home/larry/slorba/bluepills
flutter devices
flutter run -d <device-id>
```

## Option 3: Web Development

For quick testing, you can also run BluePills as a web app:

```bash
cd /home/larry/slorba/bluepills
flutter run -d chrome
# Or
flutter run -d web-server --web-port=8080
# Then open browser on Windows: http://localhost:8080
```

## Automated Setup Script

Create a helper script `wsl-emulator.sh` in the project root:

```bash
#!/bin/bash

# WSL2 Android Emulator Helper Script

WSL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

echo "🚀 BluePills WSL2 Emulator Helper"
echo "=================================="
echo ""

function show_menu() {
    echo "Select an option:"
    echo "1. Connect to Windows emulator"
    echo "2. List devices"
    echo "3. Run app on emulator"
    echo "4. Run app on physical device"
    echo "5. Run web version"
    echo "6. Kill ADB server and reconnect"
    echo "7. Exit"
    echo ""
}

function connect_adb() {
    echo "📱 Connecting to Windows ADB server..."
    export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
    adb kill-server 2>/dev/null
    sleep 1
    adb devices
    echo "✅ Connected to $WSL_HOST:5037"
}

function list_devices() {
    echo "📋 Available devices:"
    flutter devices
}

function run_emulator() {
    echo "🏃 Running on emulator..."
    flutter run
}

function run_physical() {
    echo "📱 Running on physical device..."
    flutter devices
    read -p "Enter device ID: " DEVICE_ID
    flutter run -d "$DEVICE_ID"
}

function run_web() {
    echo "🌐 Running web version..."
    flutter run -d chrome
}

function reset_adb() {
    echo "🔄 Resetting ADB connection..."
    adb kill-server 2>/dev/null
    sleep 2
    connect_adb
}

while true; do
    show_menu
    read -p "Enter choice [1-7]: " choice
    echo ""
    
    case $choice in
        1) connect_adb ;;
        2) list_devices ;;
        3) run_emulator ;;
        4) run_physical ;;
        5) run_web ;;
        6) reset_adb ;;
        7) echo "👋 Goodbye!"; exit 0 ;;
        *) echo "❌ Invalid option" ;;
    esac
    echo ""
    read -p "Press Enter to continue..."
    clear
done
```

Make it executable:
```bash
chmod +x wsl-emulator.sh
./wsl-emulator.sh
```

## Performance Tips

1. **Allocate more resources to WSL2**:
   
   Create/edit `C:\Users\<YourUsername>\.wslconfig`:
   ```ini
   [wsl2]
   memory=8GB
   processors=4
   swap=2GB
   ```
   
   Restart WSL2:
   ```powershell
   wsl --shutdown
   ```

2. **Use x86_64 emulator images** instead of ARM for better performance on Intel/AMD CPUs

3. **Enable hardware acceleration** in Windows emulator:
   - Ensure Intel HAXM or AMD Hypervisor is installed
   - Enable Hyper-V in Windows features

4. **Close unnecessary apps** on Windows when running emulator

## Common Issues and Solutions

### Issue: "unable to connect to 127.0.0.1:5037"
**Solution**: Use the Windows host IP instead:
```bash
export ADB_SERVER_SOCKET=tcp:$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):5037
```

### Issue: Emulator is slow
**Solution**: 
- Use a physical device instead
- Allocate more RAM to emulator in AVD settings
- Use x86_64 system images

### Issue: "daemon not running" errors
**Solution**:
```bash
# On Windows PowerShell:
adb.exe kill-server
adb.exe -a -P 5037 start-server

# On WSL2:
adb kill-server
adb devices
```

### Issue: USB device not showing in WSL2
**Solution**:
```powershell
# In PowerShell (as Administrator):
usbipd list
usbipd attach --wsl --busid <BUS_ID>
```

## Quick Reference

```bash
# Connect to Windows ADB
export ADB_SERVER_SOCKET=tcp:$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):5037

# Check devices
adb devices
flutter devices

# Run app
flutter run

# Hot reload
# Press 'r' in terminal while app is running

# Hot restart
# Press 'R' in terminal while app is running

# Install on specific device
flutter install -d <device-id>

# Build APK
flutter build apk --release
```

## Additional Resources

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Flutter WSL Setup](https://docs.flutter.dev/get-started/install/windows#wsl2)
- [Android Debug Bridge (ADB)](https://developer.android.com/studio/command-line/adb)
- [USBIPD for Windows](https://github.com/dorssel/usbipd-win)

## Summary

For BluePills development on WSL2, the recommended approach is:

1. **Install Android Studio on Windows** and create an AVD
2. **Start the emulator on Windows**
3. **Connect from WSL2** using the ADB bridge
4. **Run Flutter commands** from your WSL2 terminal

This setup provides the best balance of performance, ease of use, and integration with your WSL2 development environment.
