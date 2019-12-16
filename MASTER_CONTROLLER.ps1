#$user_answer = Read-Host -Prompt 'What would you like to do?!'

function show_menu{
param(
[string]$Title = 'Main Menu'
)


write-host " ========== $Title =========="
write-host " ===== MODE: $connection_mode =====

"

write-host "1. (K) Kill ADB Server (Do first if you're not sure!)"
write-host "1.5(C) Attempt a connection with the client in settings.txt"
write-host "2. (D) Device List - Check if any devices show up"
write-host "3. (ID) ID-Check to display whats stored in settings.txt. Also updates the clientID Variable"
write-host "4. (IDC)ID-Check to confirm whats in settings.txt matches whats found in your phones settings About section"
write-host "5. (W) Wifi Mode (Device Must be Connected via USB)"
write-host "6. (U) USB Mode (Device Must be Connected via USB)"
write-host "S. (S) Start the screen mirroring on the currently set mode (Wifi/USB)"
write-host "Clr. (CLR) Clear the console and return to main menu.."
write-host "Q. (Q) To quit"
}

function Get_Devices{
		$devices = .\adb devices
		return $devices	
}

function Connect{
	Write-Host ">>> Attempting to connect to client.."
	.\adb connect $clientID
}

function Kill_ADB{

		.\adb kill-server
		Write-Host '>>> ADB Killed..'
		Start-Sleep 1		
		return
}

function USB_ADB{
		Kill_ADB
		.\adb usb #Reset the ADB to USB mode
		$connection_mode = "USB"
		Write-Host ">>> ADB Set to USB... "
		Start-Sleep 1
}

function Wifi_ADB{
		Kill_ADB
		
		#.\adb usb #Reset the ADB to USB mode
		#Write-Host ">>> ADB Set to USB mode.."
		#Start-Sleep 1
		
		.\adb tcpip 5556 #Re-Set to TCPIP MOde, set port to 5556
		Write-Host ">>> ADB Set back to TCPIP:5556"
		Start-Sleep 1
		write-host "disconnect any device from the USB cable and hit any button to continute..."
		pause
		
		.\adb connect $clientID #connect to ADB
		$connection_mode = "WIFI"
		Write-Host ">>> Connecting to ADB Remote..."
		Start-Sleep 1
		#write-host "Connection attempt made; Test it by (S)tarting the mirror now!"
	return
}

function start_scrcpy{
.\scrcpy #Run the screen copy applet
}

#not using this func anymore as i could handle it with the clientID line in the DO-UNTIL loop.
function set_client_id(){
#$input = read-host "Whats the IP Address of your device?"
$input = Get-Content -Path .\settings.txt
$clientID = $input
return $input
}

$global:connection_mode = "default"

do{
	$global:clientID = Get-Content -Path .\settings.txt -TotalCount 1 #IP address of the device you want to connect to, find this in the 'About Phone' section in your phones settings window
	$array = "k","d","clr","c","q","id","idc","u","w","s" #add any valid choices to this array for it to work
	#set_client_id
	show_menu
	$selection = Read-Host "Input"
		if($array -notcontains $selection){
		write-host "$selection isnt a valid input...try again!"
		}else{
		
			switch($selection)
			{
				'k' { 
					'>>> You chose to kill the ADB Server'
					Kill_ADB
					}
				'd' {
					'>>> Openining the device list'
					Get_Devices
					}
				'clr' {
					clear-host
					}
				'id'{					
					$clientID = set_client_id
					#write-host "$clientID is the address currently set"
					}
				'idc'{
					write-host "$clientID << is the address currently set"
					 }
				"u"  {
						USB_ADB
					 }
				"w"  {
						Wifi_ADB
					 }
				"s"  {
						start_scrcpy
					 }
			}
		}
	pause
}
until($selection -eq 'q')