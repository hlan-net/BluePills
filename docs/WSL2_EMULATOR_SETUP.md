# Running Android Emulator on WSL2

This guide explains how to run the Android emulator for BluePills development on WSL2 (Windows Subsystem for Linux 2).

## Prerequisites

- Windows 11 or Windows 10 with WSL2 enabled
- Android Studio installed on Windows
- Flutter development environment set up in WSL2

## Overview

Since WSL2 doesn't have direct access to the GPU for hardware acceleration, we have two main approaches:

1. **Use Windows-side Android Emulator (Recommended)**
2. **Use WSL2-native Android Emulator (Advanced)** - Requires KVM setup
3. **Connect to a Physical Device via ADB**

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

## Option 2: WSL2-native Android Emulator (Advanced)

This option runs the Android emulator directly in WSL2 using KVM for hardware acceleration. This is more complex but can be useful if you prefer to keep everything in Linux.

### Prerequisites for WSL2 Emulator

1. **Windows 11 build 22000 or higher** (or Windows 10 with WSL2 kernel 5.10.60.1+)
2. **Nested virtualization enabled**

### Step 1: Enable Nested Virtualization

In PowerShell (as Administrator):

```powershell
# Check Windows version
winver

# Enable nested virtualization for WSL2
Set-VMProcessor -VMName <WSL2VMName> -ExposeVirtualizationExtensions $true

# If you get an error finding the VM name, try:
Get-VM | Where-Object {$_.Name -like "*WSL*"}
```

Alternatively, edit `.wslconfig`:

```ini
# C:\Users\<YourUsername>\.wslconfig
[wsl2]
nestedVirtualization=true
memory=8GB
processors=4
```

Then restart WSL2:
```powershell
wsl --shutdown
```

### Step 2: Install and Configure KVM in WSL2

```bash
# Check if KVM is available
ls -la /dev/kvm
# If it doesn't exist, continue with installation

# Install KVM and QEMU
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Load KVM modules
sudo modprobe kvm
sudo modprobe kvm_intel  # For Intel CPUs
# OR
sudo modprobe kvm_amd    # For AMD CPUs

# Verify KVM is loaded
lsmod | grep kvm

# Check if /dev/kvm exists now
ls -la /dev/kvm
```

### Step 3: Add User to KVM Group

This is crucial for running the emulator without sudo:

```bash
# Add your user to the kvm group
sudo usermod -aG kvm $USER

# Also add to libvirt group for better permissions
sudo usermod -aG libvirt $USER

# Verify group membership (won't show immediately)
groups $USER

# Change the permissions on /dev/kvm
sudo chmod 666 /dev/kvm
# Or more securely:
sudo chown root:kvm /dev/kvm
sudo chmod 660 /dev/kvm
```

### Step 4: Apply Group Changes

The group membership won't take effect until you log out and back in. You have several options:

**Option A: Restart WSL2 (Recommended)**
```powershell
# In PowerShell
wsl --shutdown
# Then reopen your WSL2 terminal
```

**Option B: Start a new login shell**
```bash
# In WSL2 terminal
su - $USER
# Enter your password when prompted

# Verify KVM access
groups
# Should now show 'kvm' in the list
```

**Option C: Use newgrp (Temporary)**
```bash
# Switch to kvm group in current session
newgrp kvm

# Verify
groups
```

**Option D: Full logout**
```bash
# Exit all WSL2 terminals, then shutdown
exit
# Then in PowerShell:
wsl --shutdown
```

### Step 5: Verify KVM Access

```bash
# Check if you have KVM access
ls -la /dev/kvm
# Should show: crw-rw---- 1 root kvm

# Test KVM access
kvm-ok
# If not found, install:
sudo apt install cpu-checker
kvm-ok

# Verify you can access KVM without sudo
[ -r /dev/kvm ] && [ -w /dev/kvm ] && echo "KVM access OK" || echo "KVM access denied"

# Alternative check
test -r /dev/kvm && test -w /dev/kvm && echo "Success" || echo "Failed"
```

### Step 6: Install Android SDK and Emulator in WSL2

```bash
# Install required dependencies
sudo apt update
sudo apt install -y \
    libc6:amd64 libc6:i386 \
    libstdc++6:amd64 libstdc++6:i386 \
    lib32z1 \
    libgl1-mesa-glx \
    libpulse0 \
    libx11-6:amd64

# Install Android command line tools
cd ~
mkdir -p android-sdk/cmdline-tools
cd android-sdk/cmdline-tools

# Download command line tools (check for latest version at developer.android.com)
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest

# Add to PATH
echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.bashrc
echo 'export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH' >> ~/.bashrc
echo 'export PATH=$ANDROID_HOME/platform-tools:$PATH' >> ~/.bashrc
echo 'export PATH=$ANDROID_HOME/emulator:$PATH' >> ~/.bashrc
source ~/.bashrc

# Accept licenses
sdkmanager --licenses

# Install necessary SDK packages
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
sdkmanager "emulator" "system-images;android-34;google_apis;x86_64"

# Create an AVD
avdmanager create avd -n Pixel8_API34 -k "system-images;android-34;google_apis;x86_64" -d pixel_8

# Verify AVD was created
avdmanager list avd
```

### Step 7: Run Emulator in WSL2

```bash
# Start the emulator with KVM acceleration
emulator -avd Pixel8_API34 -no-audio -no-boot-anim -no-snapshot -gpu swiftshader_indirect

# If you get permission errors on /dev/kvm:
# 1. Check group membership
groups

# 2. If kvm not shown, you need to restart WSL2
# In PowerShell:
wsl --shutdown

# Then restart WSL2 and try again
```

### Step 8: Verify Emulator is Running

```bash
# In another terminal
adb devices
# Should show:
# List of devices attached
# emulator-5554    device

# Run Flutter app
cd /home/larry/slorba/bluepills
flutter devices
flutter run
```

### Troubleshooting WSL2 Native Emulator

#### Issue: "/dev/kvm not found" or "Permission denied"

**Check if KVM exists:**
```bash
ls -la /dev/kvm
```

**If it doesn't exist:**
```bash
# Load KVM module
sudo modprobe kvm
sudo modprobe kvm_intel  # or kvm_amd

# Make it persistent
echo "kvm" | sudo tee -a /etc/modules
echo "kvm_intel" | sudo tee -a /etc/modules  # or kvm_amd
```

**If permission denied:**
```bash
# Check group membership
groups
# If 'kvm' not shown, add yourself and restart:
sudo usermod -aG kvm $USER

# Then MUST restart WSL2
# In PowerShell:
wsl --shutdown
```

**Temporary fix (until you restart):**
```bash
sudo chmod 666 /dev/kvm
```

#### Issue: "KVM not available" error

**Verify nested virtualization:**
```bash
# Check if virtualization is available
egrep -c '(vmx|svm)' /proc/cpuinfo
# Should return a number > 0

# Check KVM
cat /sys/module/kvm_intel/parameters/nested
# Should show: Y or 1
```

**Enable in Windows:**
```powershell
# PowerShell as Administrator
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
# Should show: State : Enabled

# If not enabled:
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

#### Issue: Emulator starts but is very slow

**Solution:** Use headless mode and software rendering:
```bash
emulator -avd Pixel8_API34 \
    -no-window \
    -no-audio \
    -no-boot-anim \
    -gpu swiftshader_indirect \
    -qemu -enable-kvm
```

#### Issue: "Cannot add user to kvm group"

```bash
# Create kvm group if it doesn't exist
sudo groupadd kvm

# Add user
sudo usermod -aG kvm $USER

# Change /dev/kvm ownership
sudo chown root:kvm /dev/kvm
sudo chmod 660 /dev/kvm

# Verify
ls -la /dev/kvm
# Should show: crw-rw---- 1 root kvm
```

### Automated KVM Setup Script

Create `setup-wsl2-kvm.sh`:

```bash
#!/bin/bash

echo "🔧 Setting up KVM for Android Emulator in WSL2"
echo "==============================================="
echo ""

# Check if running in WSL2
if ! grep -q Microsoft /proc/version; then
    echo "❌ This script must be run in WSL2"
    exit 1
fi

echo "📦 Installing KVM packages..."
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils cpu-checker

echo "🔌 Loading KVM modules..."
sudo modprobe kvm 2>/dev/null || echo "⚠️  KVM module not available"

# Detect CPU vendor
if grep -q "Intel" /proc/cpuinfo; then
    echo "🔵 Intel CPU detected"
    sudo modprobe kvm_intel 2>/dev/null || echo "⚠️  Intel KVM module not available"
elif grep -q "AMD" /proc/cpuinfo; then
    echo "🔴 AMD CPU detected"
    sudo modprobe kvm_amd 2>/dev/null || echo "⚠️  AMD KVM module not available"
fi

echo "👥 Creating kvm group (if not exists)..."
sudo groupadd -f kvm

echo "👤 Adding $USER to kvm group..."
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

echo "🔐 Setting /dev/kvm permissions..."
if [ -e /dev/kvm ]; then
    sudo chown root:kvm /dev/kvm
    sudo chmod 660 /dev/kvm
    echo "✅ /dev/kvm permissions set"
else
    echo "⚠️  /dev/kvm not found - may need to enable nested virtualization in Windows"
fi

echo ""
echo "✅ KVM setup complete!"
echo ""
echo "⚠️  IMPORTANT: You must restart WSL2 for group changes to take effect:"
echo "   1. Exit all WSL2 terminals"
echo "   2. In PowerShell run: wsl --shutdown"
echo "   3. Restart your WSL2 terminal"
echo ""
echo "📋 After restart, verify with:"
echo "   groups           # Should show 'kvm'"
echo "   ls -la /dev/kvm  # Should show: crw-rw---- 1 root kvm"
echo "   kvm-ok           # Should show KVM is available"
echo ""
```

Make it executable and run:
```bash
chmod +x setup-wsl2-kvm.sh
./setup-wsl2-kvm.sh
```

Then **MUST restart WSL2**:
```powershell
# In PowerShell
wsl --shutdown
```

## Option 3: Physical Android Device

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

## Option 4: Web Development

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
