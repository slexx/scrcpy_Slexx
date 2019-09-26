.\adb kill-server
Read-Host -prompt "Enter to Continue.."
.\adb devices #check if the device is detected first
Read-Host -prompt "Hit enter if device is detected above, Otherwise close the window!... 1/3"
.\adb usb #Reset the ADB to USB mode
Read-Host -prompt "Enter to continue.. 2/3"
.\adb tcpip 5555 #Re-Set to TCPIP MOde, set port to 5555
Read-Host -prompt "Enter to continue.. 3/3 DISCONNECT THE DEVICE FROM USB.."
.\adb connect 192.168.0.30:5555 #connect to ADB
.\scrcpy -b 2M #run screen Copy for WIFI settings (reduced BW)
Read-Host -prompt "Resetting ADB Connection successful! Press Enter to exit..."