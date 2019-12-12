<#$opt1 = Read-Host -prompt "What would you like to do?.."
if($opt1 -eq '1'){ 
Write-Host "you chose 1"
}elseif($opt1 -eq '2'){
Write-Host "you chose 2"
}else{
Write-Host "Enter correct choice please.."
} 

123test

OLD SHIT, IGNORE
#>

<#
Source: https://github.com/Genymobile/scrcpy
This is a basic enough script taking user input to handle resetting the ADB Connection to the phone
while also being able to run scrcpy or check devices

Creator: SlexxSAE
#>


#Start-Process powershell.exe -ArgumentList "-NoExit .\PS_RUN_SCRCPY.ps1"


#This func will ask for user input and check if the $input matches any of the values in $array, otherwise calling itself again
function user_input{
	#Array to store potential correct answers to trigger a switch statemen
    $array = "w","s","d","x","t","l","k","p" #each option added to the switch needs to be added here!
    
    #Takes the input given by user
	$input = Read-Host '	>>MAIN MENU<<
	
OPTIONS:
(K) Kill ADB Server (Step 1 if you dont know what you are doing..)
(D) Devices List
(W) Reset ADB to Wifi(TCPIP)
(L) Reset ADB to Local(USB)
(S) Start
(X) Exit 
(T) Test 
>> Your Input? '
	
	#If input isnt in the array above, ask for input again
	if($array -notcontains $input){
		Write-Host ">>> Not a correct answer, Try again..."
		#user_input #calls this function if the $input didnt match $array
		return user_input
	}
    
    #on a correct answer- returns answer for use
	return $input 
}


function test_func($a){
    $a = Read-Host 'What would you like to store in this var?'
    Write-Host $a ' is what you passed to this function!'
}

function Get_Devices{
		$devices = .\adb devices
		return $devices	
}

function Kill_ADB{

		.\adb kill-server
		Write-Host '>>> ADB Killed..'
		Start-Sleep 1		
		return
}

#1. Kills ADB (To Reset) 2. sets ADB to USB
function Wifi_ADB{
		Kill_ADB
		
		.\adb usb #Reset the ADB to USB mode
		Write-Host ">>> ADB Set to USB mode.."
		Start-Sleep 1
		
		.\adb tcpip 5555 #Re-Set to TCPIP MOde, set port to 5555
		Write-Host ">>> ADB Set back to TCPIP:5555"
		Start-Sleep 1
		
		.\adb connect 192.168.0.30:5555 #connect to ADB
		Write-Host ">>> Connecting to ADB Remote..."
		Start-Sleep 1
	return
}

function USB_ADB{
		Kill_ADB
		.\adb usb #Reset the ADB to USB mode
		Write-Host ">>> ADB Set to USB... "
		Start-Sleep 1
}

function start_Mirror{
		Write-Host '>>> Starting Mirror in default res..'
		Start-Sleep 1
		.\scrcpy #run screen Copy for WIFI settings (reduced BW)
}

function exit_app{
		Write-Host '!>!> Exiting app.. <!<!'
		Start-Sleep 2
		exit
}


#END FUNCTIONS


#VARIABLES
$input = user_input
$clientIP = "192.168.0.30:5555" #just testing variables and how they apply

#$client = $null

switch($input)
{
    #option 'W'
    w {
		Wifi_ADB		
	}
	#option 'L'
	l {
		USB_ADB		
	}
	#option 'S'
    s {
		start_Mirror
	}
	#option 'D'
    d {
	Get_Devices
	user_input		
	}
	#option 'K'
	k {
		Kill_ADB
		user_input		
	}
	#option 'X'
	x {exit_app}
	#option 'T'
	t {	
		test_func(0)
		user_input			
	}
	
	default {
		user_input
		#return
	}
}
#Read-Host ' >>> Something went wrong, Restart the script! '


#pause
#user_input