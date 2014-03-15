(*
Based almost entirely on https://forum.utorrent.com/viewtopic.php?pid=654898 by Jack0817 at 2012-04-16 19:42:30
A copy of the original is included in "original.scpt".

Code update is for handling Viscosity, instead of OSX VPN via calls to "System Events".
Modifications for Viscosity: Louis T. Getterman IV - http://Thad.Getterman.org/
*)

------------------------------------------------
--Main Routine
------------------------------------------------
on idle
	
	--Script Variables
	set appName to "uTorrent"
	set vpnName to "IPredator"
	set waitTime to 1 as integer
	
	--Main Script Logic
	if isViscosityVPNConnected(vpnName) then
		--		notifyOSX("VPN Predator Connected", "Connection to "+vpnName+" established...")
		startApplication(appName)
	else
		--		notifyOSX("Resetting Viscosity Connection", "Connection to "+vpnName+" razed.  Attempting to reset & waiting 30 seconds...")
		stopApplication(appName)
		
		-- disconnect connection(s) since Viscosity sometimes hangs on attempting to reconnect to IPredator, and doing so will also reset the network interfaces (assuming you remembered to set the option, right?)
		--tell application "Viscosity" to disconnectall
		tell application "Viscosity" to disconnect vpnName
		
		-- wait few seconds so that we can also give time for network connection(s) to reset, and reconnect
		delay 30
		
		-- attempt to reconnect
		--		notifyOSX("Reestablishing Viscosity connection", "30 seconds is up, attempting to connect to "+vpnName+"...")
		connectViscosityVPNConnection(vpnName)
		
		-- give some time to cool off, and hope that we have a winner (as compare to some obscure TLS-handshake issues)
		delay 60
		
		if isViscosityVPNConnected(vpnName) then
			--        notifyOSX("Oh, the humanity!", "We waited 60 seconds, and still bupkas.  Life can be cruel sometimes...  Did you forget to pay the bill?")
		end if
		
	end if
	
	return waitTime
	
end idle

------------------------------------------------
--Sub Routine - Determines if specified Viscosity vpn is connected
------------------------------------------------
on notifyOSX(notifyTitle, notifyMsg)
	
	set theNotif to current application's NSUserNotification's alloc()'s init()
	tell theNotif
		setTitle_(notifyTitle)
		setInformativeText_(notifyMsg)
	end tell
	tell current application's NSUserNotificationCenter's defaultUserNotificationCenter()
		setDelegate_(me)
		deliverNotification_(theNotif)
	end tell
	
	-- this was causing errors since it's sitting inside of a sub-routine :'-(
	--	on userNotificationCenter_shouldPresentNotification_(cen, notif) -- delegate method
	--		return yes
	--	end userNotificationCenter_shouldPresentNotification_
	
end notifyOSX

------------------------------------------------
--Sub Routine - Determines if specified Viscosity vpn is connected
------------------------------------------------
on isViscosityVPNConnected(vpnName)
	
	--Init return value to default
	set isConnected to false
	set connectionState to {"Disconnected"}
	
	tell application "Viscosity"
		set connectionState to state of connections where name is equal to vpnName
	end tell
	
	if connectionState is equal to {"Connected"} then
		set isConnected to true
	else
		set isConnected to false
	end if
	
	return isConnected
	
end isViscosityVPNConnected

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
--Sub Routine - Attempts to connect to the Viscosity specified VPN
------------------------------------------------
on connectViscosityVPNConnection(vpnName)
	
	if viscosityVPNConnectionIsExist(vpnName) is true then
		tell application "Viscosity" to connect vpnName
	end if
	
end connectViscosityVPNConnection

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
--Sub Routine - Determines if specified connection exists in Viscosity
------------------------------------------------
on viscosityVPNConnectionIsExist(vpnName)
	
	--Init return value to default
	set isExist to false
	set connectionState to {}
	
	tell application "Viscosity"
		set connectionState to state of connections where name is equal to vpnName
	end tell
	
	if connectionState is not equal to {} then
		set isExist to true
	else
		set isExist to false
	end if
	
	return isExist
	
end viscosityVPNConnectionIsExist

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
