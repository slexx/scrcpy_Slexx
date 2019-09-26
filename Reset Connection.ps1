.\adb kill-server
Read-Host -prompt "ADB Server killed! 1/4"
.\adb devices #check if the device is detected first
Read-Host -prompt "Hit enter if device(s) are detected above, Otherwise close the window!... 2/4"
.\adb usb #Reset the ADB to USB mode
Read-Host -prompt "Enter to continue.. 2/3"
.\adb tcpip 5555 #Re-Set to TCPIP MOde, set port to 5555
Read-Host -prompt "Enter to continue.. 3/3 DISCONNECT THE DEVICE FROM USB.."
.\adb connect 192.168.0.30:5555 #connect to ADB
.\scrcpy -b 2M #run screen Copy for WIFI settings (reduced BW)
Read-Host -prompt "Resetting ADB Connection successful! Press Enter to exit..."