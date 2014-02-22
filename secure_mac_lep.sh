#!/bin/bash

echo "# Removing BlueTooth Support Software "
echo "# ----------------------------- "
# Remove Bluetooth kernel extensions. 
srm -rf /System/Library/Extensions/IOBluetoothFamily.kext 
srm -rf /System/Library/Extensions/IOBluetoothHIDDriver.kext 
# Remove Extensions cache files.
touch /System/Library/Extensions

echo "# Removing IR Support Software"
echo "# -----------------------------"
# Remove IR kernel extensions. 
srm -rf /System/Library/Extensions/AppleIRController.kext 
# Remove Extensions cache files. 
touch /System/Library/Extensions

echo "# Securing Audio Support Software" 
echo "# -----------------------------" 
# Remove Audio Recording kernel extensions. 
srm -rf /System/Library/Extensions/AppleOnboardAudio.kext 
srm -rf /System/Library/Extensions/AppleUSBAudio.kext 
srm -rf /System/Library/Extensions/AppleDeviceTreeUpdater.kext 
srm -rf /System/Library/Extensions/IOAudioFamily.kext 
srm -rf /System/Library/Extensions/VirtualAudioDriver.kext 
# Remove Extensions cache files. 
touch /System/Library/Extensions

echo "# Securing Video Recording Support Software" 
echo "# -----------------------------" 
# Remove Video Recording kernel extensions. 
# Remove external iSight camera.
srm -rf /System/Library/Extensions/Apple_iSight.kext 
# Remove internal iSight camera. 
srm -rf /System/Library/Exensions/IOUSBFamily.kext/Contents/PlugIns/\
        AppleUSBVideoSupport.kext 
# Remove Extensions cache files. 
touch /System/Library/Extensions

echo "# Securing FireWire Support Software" 
echo "# ----------------------------- "
# Remove FireWire kernel extensions. 
srm -rf /System/Library/Extensions/IOFireWireSerialBusProtocolTransport.kext 
# Remove Extensions cache files.
touch /System/Library/Extensions

echo "# Enabling Access Warning for the Login Window" 
echo "# ----------------------------------" 
# Create a login window access warning.
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This is a Private Computer System, if you do not have permission to use this system please leave. Your actions are being logged"

echo
echo "# -------------------------------------------------------------------" 
echo "# Securing System Preferences"
echo "# -------------------------------------------------------------------"
echo "# Securing MobileMe Preferences"
echo "# -------------------------" 
echo "# Disable Sync options." 
defaults -currentHost write com.apple.DotMacSync ShouldSyncWithServer 1

echo "# Securing Appearance Preferences" 
echo "# -----------------------------" 
echo "# Disable display of recent applications." 
defaults write com.apple.recentitems Applications -dict MaxAmount 0
echo "# Securing Bluetooth Preferences" 
echo "# -----------------------------" 
echo "# Turn Bluetooth off." 
defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
echo "# Securing CDs & DVDs Preferences"
echo "# -----------------------------" 
echo "# Disable blank CD automatic action." 
defaults write /Library/Preferences/com.apple.digihub com.apple.digihub.blank.cd.appeared -dict action 1 
echo "# Disable music CD automatic action." 
defaults write /Library/Preferences/com.apple.digihub com.apple.digihub.cd.music.appeared -dict action 1 
echo "# Disable picture CD automatic action." 
defaults write /Library/Preferences/com.apple.digihub com.apple.digihub.cd.picture.appeared -dict action 1 
echo "# Disable blank DVD automatic action." 
defaults write /Library/Preferences/com.apple.digihub com.apple.digihub.blank.dvd.appeared -dict action 1 
echo "# Disable video DVD automatic action." 
defaults write /Library/Preferences/com.apple.digihub com.apple.digihub.dvd.video.appeared -dict action 1

echo "# Securing Desktop & Screen Saver Preferences" 
echo "# -----------------------------" 
# Set idle time for screen saver. XX is the idle time in seconds. 
defaults -currentHost write com.apple.screensaver idleTime -int 5

echo "# Securing Energy Saver Preferences" 
echo "# -----------------------------" 
echo "# Disable computer sleep." 
pmset -a sleep 0
echo "# Disable hard disk sleep." 
pmset -a disksleep 0 
echo "# Disable Wake for Ethernet network administrator access." 
pmset -a womp 0 
# Disable Restart automatically after power failure. pmset -a autorestart 0

echo "# Securing Expose & Spaces Preferences"
echo "# -----------------------------" 
echo "# Disable dashboard." 
defaults write com.apple.dashboard mcx-disabled -boolean YES
echo "# Securing Keyboard & Mouse Preferences" 
echo "# -----------------------------" 
# Disable Bluetooth Devices to wake computer. 
defaults write /Library/Preferences/com.apple.Bluetooth \
	BluetoothSystemWakeEnable -bool 0

echo "# Securing Printer & Fax Preferences" 
echo "# -----------------------------" 
# Disable the receiving of faxes. 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.efax.plist 
# Disable printer sharing.
cp /etc/cups/cupsd.conf /tmp/cupsd.conf 
if /usr/bin/grep "Port 631" /etc/cups/cupsd.conf 
then
 /usr/bin/sed "/^Port 631.*/s//Listen localhost:631/g" /tmp/cupsd.conf > /etc/cups/cupsd.conf
else 
 echo "Printer Sharing not on"
fi

echo "# Securing Security Preferences"
echo "# -----------------------------" 
echo "# Enable Require password to wake this computer from sleep or screen saver." 
defaults -currentHost write com.apple.screensaver askForPassword -int 1 

# Disable Automatic login. 
#defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes 

# Requiring password to unlock each System Preference pane. 
# Edit the /etc/authorization file using a text editor. 
# Find <key>system.preferences<key>. 
# Then find <key>shared<key>. 
# Then replace <true/> with <false/>. 
# Disable automatic login. 
#defaults write /Library/Preferences/.GlobalPreferences \ com.apple.autologout.AutoLogOutDelay -int 0 

echo "# Enable secure virtual memory." 
defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool yes 
echo "# Disable IR remote control." 
defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no 

# Enable FileVault. 
# To enable FileVault for new users, use this command. 
# /System/Library/CoreServices/ManagedClient.app/Contents/Resources/ createmobileaccount 

# Enable Firewall. 
# where value is # 0 = off 
# 1 = on for specific services 
# 2 = on for essential services 
# defaults write /Library/Preferences/com.apple.alf globalstate -int value 

# Enable Stealth mode. 
# defaults write /Library/Preferences/com.apple.alf stealthenabled 1 

# Enable Firewall Logging. 
# defaults write /Library/Preferences/com.apple.alf loggingenabled 1

echo "# Securing Software Updates Preferences" 
echo "# -----------------------------" 
# Disable check for updates and Download important updates automatically. 
softwareupdate --schedule off

echo "# Securing Sound Preferences" 
echo "# -----------------------------" 
# Disable internal microphone or line-in. 
# This command does not change the input volume for all input devices, it 
# only sets the default input device volume to zero. 
osascript -e "set volume input volume 0"

echo "# Securing Speech Preferences" 
echo "# -----------------------------" 
# Disable Speech Recognition. 
defaults write "com.apple.speech.recognition.AppleSpeechRecognition.prefs" StartSpeakableItems -bool false 
# Disable Text to Speech settings. 
defaults write "com.apple.speech.synthesis.general.prefs" TalkingAlertsSpeakTextFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenNotificationAppActivationFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenUIUseSpeakingHotKeyFlag -bool false 
defaults delete "com.apple.speech.synthesis.general.prefs" TimeAnnouncementPrefs

echo "# Securing Spotlight Preferences"
echo "# -----------------------------" 
# Disable Spotlight for a volume and erase its current meta data, where 
# $volumename is the name of the volume. $ 
mdutil -E -i off OSBoot

echo
echo "# -------------------------------------------------------------------" 
echo "# Information Assurance with Services" 
echo "# -------------------------------------------------------------------" 
echo "# DVD or CD Sharing"
echo "# -------------------------" 
echo "# Disable DVD or CD Sharing." 
service com.apple.ODSAgent stop


echo "# Screen Sharing (VNC)" 
echo "# -------------------------" 
echo "# Disable Screen Sharing." 
srm /Library/Preferences/com.apple.ScreenSharing.launchd

echo "# Disable File Sharing services." 
echo "# -------------------------" 
echo "# Disable FTP." 
launctl unload -w /System/Library/LaunchDaemons/ftp.plist 

echo "# Disable SMB."
defaults delete /Library/Preferences/SystemConfiguration/ com.apple.smb.server EnabledServices
launctl unload -w /System/Library/LaunchDaemons/nmbd.plist
launctl unload -w /System/Library/LaunchDaemons/smbd.plist

echo "# Disable AFP." 
launctl unload -w /System/Library/LaunchDaemons/ com.apple.AppleFileServer.plist

echo "# -----------------------------" 
echo "# Web Sharing" 
echo "# -----------------------------" 
# Disable Web Sharing service. 
launctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 

echo
echo "# Remote Management (ARD)" 
echo "# -----------------------------" 
# Disable Remote Management. 
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/\
	Resources/kickstart -deactivate -stop

echo "# Remote Apple Events (RAE)" 
echo "# -----------------------------" 
# Disable Remote Apple Events. 
launchctl unload -w /System/Library/LaunchDaemons/eppc.plist

echo "# Xgrid Sharing" 
echo "# -----------------------------" 
# Disable Xgrid Sharing. 
xgridctl controller stop 
xgridctl agent stop

echo "# Internet Sharing" 
echo "# -----------------------------" 
echo "# Disable Internet Sharing." 
defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
launctl unload -w /System/Library/LaunchDaemons/ com.apple.InternetSharing.plist

echo "# Bluetooth Sharing" 
echo "# -----------------------------" 
echo "# Disable Bluetooth Sharing." 
defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled 0
