<h1> firefox-extensions-autoinstall </h1>
<p1> detects any profile directory inside the .mozilla/firefox, .mozilla/firefox-developer-edition, and Tor’s profile directory (tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default. The 
script works with any profile it finds that is firefox based. If the extension .xpi file is already downloaded to /tmp, it won't be downloaded again, saving time. </p1>

<h2> to do - add extension for Secure SNI, make the script work again (isnt working as of today, I believe its due to how firefox based browsers handle extension signing, i am working on a solution) </h2>



<h2> prerequisites </h2>

    sudo apt-get install jq


<h2> Extension List </h2>
<p2>
Bitwarden Password Manager
OpenVideo
NoScript
Buster Captcha Solver
View Page Archive
Search by Image
Privacy Possum
Privacy Badger 17
Location Guard
Flagfox
Ghostery
Fake Filler
DuckDuckGo for Firefox
Disconnect
Happy Bonobo Disable WebRTC
Decentraleyes
Dark Reader
ClearURLs
CanvasBlocker
User-Agent String Switcher
AdNauseam
WhatCampaign
Violent Monkey
uBlock Origin
HackTools
JavaScript Restrictor
</p2>

<h2> Use Guide - Linux </h2>
Save the Script: ffeail.sh

Make it Executable: chmod +x ffeail.sh

Run: ./ffeail.sh

<h2> Use Guide - Windows (gross, ew, yuck) </h2>
1.Install WSL:
    Open PowerShell as Administrator and run:
        wsl --install
    Restart your system if prompted.

Install a Linux Distro Windows Subsystem:

    After restarting, set up your preferred Linux distribution (e.g., Kali linux) through the Microsoft Store.

Access WSL and Run the Script:

    Once WSL is installed, open a WSL terminal (you can type wsl in PowerShell).
    Copy the Bash script to the WSL file system or open the script from a Windows directory in WSL (e.g., /mnt/c/Users/YourUsername/Downloads/install_firefox_extensions.sh).

Then you can make the script executable:

  chmod +x install_firefox_extensions.sh

  Run the script in WSL:

        ./install_firefox_extensions.sh

Accessing Firefox Profiles on Windows:  
  Firefox profiles are stored in C:\Users\<YourUsername>\AppData\Roaming\Mozilla\Firefox\Profiles. In WSL, you can access them via /mnt/c/Users/<YourUsername>      /AppData/Roaming/Mozilla/Firefox/Profiles.

Update the process_profiles function to point to this path:

process_profiles "Firefox" "/mnt/c/Users/YourUsername/AppData/Roaming/Mozilla/Firefox"

There you go you windows using plebs, switch to linux goddamnit
