Chameleon
=========

OSX AppleScript that maintains a persistent VPN connection through Viscosity, and shuts down uTorrent upon any interruption.

Why the name?  A Chameleon blends into it's surroundings, and uses a sticky tongue to retrieve objects.  I'd like to think that similar is happening here with blending into network surroundings, and using a sticky/persistent connection to retrieve objects.

----------
IF YOU'RE READING NOTHING ELSE, THEN *PLEASE* READ THIS!!!
* Turn off quit confirmation dialog in utorrent!
* Go to advanced options (cmd-option-,) and turn off graceful shutdown!
----------

PLEASE NOTE: This is a slight modification of code, and based almost entirely on https://forum.utorrent.com/viewtopic.php?pid=654898 by Jack0817 at 2012-04-16 19:42:30.

There have been several times where I've needed to download Ubuntu and Raspbian via BitTorrent, and a motel/hotel has nearly everything blocked, and I need to punch through and get one of those distributions so that I can be on my merry way for developing.  The specific need for this came up when I had a BitTorrent download of Ubuntu *and* Raspbian going on a VPN connection, ran out to get dinner, returned back to my hotel room and the connection had dropped; and worse yet, the hotel had blocked my computer from their network for attempting to use BitTorrent (even though it was legitimate downloads!)

I don't use OSX VPN, and instead, I use Viscosity; so I slightly modified this original script from the uTorrent forum in order to play nice with Viscosity, and after thumbing through "Controlling Viscosity with AppleScript" from the support pages (http://www.sparklabs.com/support/controlling_viscosity_with_app/)

Best regards,
Louis T. Getterman IV - http://Thad.Getterman.org/
