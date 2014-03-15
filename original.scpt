(*
Original post:
----------
Here is a script I've created that will get the job done until uTorrent (for Mac) can bind to a VPN service.  SImply update the "Scrip Variables" section with your corresponding values, save the script AS AN APP, and add it to your Login Startup Items.

The Gist: This script will monitor your VPN connection, if it detects it is no longer connected it will gracefully shutdown uTorrent (keeping all DL progress intact).  Also, when the VPN is down, it will continue to try to re-establish a connection and upon successful re-connecting, it will then re-launch uTorrent to resume where it left off.

Hope this helps!

Last edited by Jack0817 (2012-04-16 19:44:36)
*)
------------------------------------------------
--Main Routine
------------------------------------------------
on idle
   
    --Script Variables
    set appName to "uTorrent"
    set vpnName to "IPredator"
    set waitTIme to 60 as integer
   
    --Main Script Logic
    if isVPNConnected(vpnName) then
        startApplication(appName)
    else
        stopApplication(appName)
        connectVPNConnection(vpnName)
    end if
   
    return waitTIme
   
end idle

------------------------------------------------
--Sub Routine - Determines if specified vpn is connected
------------------------------------------------
on isVPNConnected(vpnName)
   
    --Init return value to default
    set isConnected to false
   
    tell application "System Events"
        tell current location of network preferences
            set vpnConnection to the service vpnName
            set isConnected to current configuration of vpnConnection is connected
        end tell
    end tell
   
    return isConnected
   
end isVPNConnected

------------------------------------------------
--Sub Routine - Attempts to connect to the specified VPN
------------------------------------------------
on connectVPNConnection(vpnName)
   
    tell application "System Events"
        tell current location of network preferences
            set vpnConnection to the service vpnName
            if vpnConnection is not null then
                connect vpnConnection
            end if
        end tell
    end tell
   
end connectVPNConnection

------------------------------------------------
--Sub Routine - Starts an application if it is not already running
------------------------------------------------
on startApplication(appName)
   
    if appIsRunning(appName) is false then
        tell application appName to activate
    end if
   
end startApplication

------------------------------------------------
--Sub Routine - Stop an application if it is running
------------------------------------------------
on stopApplication(appName)
   
    if appIsRunning(appName) then
        tell application appName to quit
    end if
   
end stopApplication

------------------------------------------------
--Sub Routine - Determines if specified app is currently running
------------------------------------------------
on appIsRunning(appName)
   
    set isRunning to false
   
    tell application "System Events"
        set isRunning to (name of processes) contains appName
    end tell
   
    return isRunning
   
end appIsRunning
