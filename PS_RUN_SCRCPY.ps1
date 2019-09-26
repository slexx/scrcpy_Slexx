<#$opt1 = Read-Host -prompt "What would you like to do?.."
if($opt1 -eq '1'){ 
Write-Host "you chose 1"
}elseif($opt1 -eq '2'){
Write-Host "you chose 2"
}else{
Write-Host "Enter correct choice please.."
} #>

<#
Source: https://github.com/Genymobile/scrcpy
This is a basic enough script taking user input to handle resetting the ADB Connection to the phone
while also being able to run scrcpy or check devices

Creator: SlexxSAE
#>

#This func will ask for user input and check if the $input matches any of the values in $array, otherwise calling itself again
function user_input{
$array = "w","s","d","x","t","l" #each option added to the switch needs to be added here!

$input = Read-Host 'OPTIONS:
(S) Start
(W) Reset ADB to Wifi(TCPIP)
(L) Reset ADB to Local(USB) 
(D) Devices List 
(X) Exit 
(T) Test 
>> Your Input?'
if($array -notcontains $input){
	Write-Host "Not a correct answer, Try again..."
	user_input #calls this function if the $input didnt match $array
}

return $input
}

$input = user_input

switch($input)
{
    w {
		.\adb kill-server
		Read-Host -prompt "ADB Server killed... 1/3"
		.\adb usb #Reset the ADB to USB mode
		Read-Host -prompt "ADB Set to USB... 2/3"
		.\adb tcpip 5555 #Re-Set to TCPIP MOde, set port to 5555
		Read-Host -prompt "ADB TCPIP Set >> DISCONNECT THE DEVICE FROM USB.. << 3/3"
		.\adb connect 192.168.0.30:5555 #connect to ADB
		user_input
	}
	l {
		.\adb kill-server
		Read-Host -prompt "ADB Server killed... 1/3"
		.\adb usb #Reset the ADB to USB mode
		Read-Host -prompt "ADB Set to USB... 2/2"
		user_input
	}
    s {
	.\scrcpy -b 2M #run screen Copy for WIFI settings (reduced BW)
	}
    d {
		.\adb devices #check if the device is detected first
	}
	x {exit}
	t {'Test Complete..'}
    default {'Try again..'}
}
#pause