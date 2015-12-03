#!/usr/bin/env bash

echo "Network Diagnostics"

################################################
########                              ##########
########                              ##########
########                              ##########
################################################

function reference {
echo "
ping
traceroute/tracert
ipconfig/ifconfig
nslookup
ip
netstat
dig
pathping/mtr
route
apr
ethtool
"
}
function display_usage {
    echo "
This script attempts to diagnose and fix network errors on linux and mac machines
-v --verbose
-f --fix_errors
-h --help
-r --reference
"
}
function process {
    echo "
verify network adapter
    installed
    detected
    up to date
wired network
    cable is connected to computer and router
    good cable
    network card light is on, green
wireless
    wifi is turned on
    correct wifi hotspot
    correct network authentication (SSID)
adapter
    make sure that the network can ping itself
    ping 127.0.0.1
    if that fails, one of:
        network card is not physically installed correctly,
        wrong drivers
        bad card
router
    make sure that the router is turned on
    ipconfig to look at gateway address
    try to ping the gateway
        if no reply, 
            eithr router is set up incorrectly or connection is bad.
            turn off computer
            unplug the router
            leave disconnectedfor 10 seconds
            turn router and comp back on and attempt to reconnect
firewall
    make sure all of the required ports are open, like 80
dhcp
"
}

verbose=0
fixing=0
red=\e[033;31m
dcolor=\e[0m


#option parsing
while [[ $# > 0 ]]
do
key="$1"
case $key in
    -v|--verbose)
    verbose=1
    shift # past argument
    ;;
    -f|--fis_errors)
    fixing=1
    shift # past argument
    ;;
    -h|--help)
    display_usage
    exit
    ;;
    -r|--reference)
    reference
    exit
    ;;
    -p|--process)
    process
    exit
    ;;
    *)
          # unknown option
    ;;
esac
shift # past argument or value
done

#=============================================
#==========Getting user input=================
#=============================================

wired=0
echo "Is the machine using a wired connection? (y|n)" 
read -r wired
if [ $wired = 'y' ] || [ $wired = 'yes' ]
then wired='y'; echo Proceeding as a wired connection;
else echo Proceeding as a wireless connection; 
fi
echo

os=0
echo "Is this machine OSX(1) or Linux(2)? (1|2)" 
read -r os
if [ $os -eq '1' ] || [ $os -eq 'mac' ]
    then $os = 'mac'; echo Proceeding as OSX;
    else if [ $os = '2' ] || [ $os -eq 'lin' ]
        then $os = 'lin'; echo Proceeding as Linux; 
        else echo unrecognized operating system.
    fi
fi
echo

echo "Press enter after each step to continue."
echo

#=============================================
#==========Physical level=====================
#=============================================

printf "\e[033;31mLayer 1: Hardware/Link\e[0m\n"
if [ $wired = 'y' ];
then 
    printf "Make sure that the ethernet cable is plugged into your computer."; read; 
    printf "Make sure that the ethernet cable is plugged into your router."; read; 
    printf "Make sure that the ethernet cable works when plugged into a different machine."; read;
    echo "Make sure that the lights on the ethernet port are on.
    The left led denotes speed. 
        Amber is 1000Mb/s, 
        Green is 100Mb/s and 
        Off is 10Mb/s or lower.
    The right led denotes activity. 
        On is an estabilshed link, 
        Blinking is port activity and 
        Off is no activity."; read; 
    
else
    printf "Make sure that you have wireless turned on."; read
    printf "Make sure that you are connected to the correct wireless hotspot."; read
    printf "Make sure you have authenticated correctly to your hotspot."; read
fi

printf "Checking ports:"
if [ $os = 'mac' ]; 
then 
    if ping -c 2 -t 500 127.0.0.1 > /dev/null
    then printf "Self ping success"
    else printf "Self ping failure"
    fi
    networksetup -listallhardwareports
    ifconfig | grep ^en
fi
if [ $os = 'lin' ]; 
then
    if ping -c 2 -t 500 127.0.0.1 > /dev/null
    then echo success
    else echo failure
    fi

    # lspci | grep -i wireless
    # ifconfig | grep 
fi

read -p "Press enter to continue.";  

# #internet layer
# printf "\e[033;31mLayer 2: Internet\e[0m"
# read -p "Press enter to continue."; echo 

# #transport layer
# printf "\e[033;31mLayer 3: Transport\e[0m"
# read -p "Press enter to continue."; echo 

# #application layer
# printf "\e[033;31mLayer 4: Application\e[0m"
# read -p "Press enter to continue."; echo 
