<h1> firefox-extensions-autoinstall </h1>
<p1> detects any profile directory inside the .mozilla/firefox, .mozilla/firefox-developer-edition, and Tor’s profile directory (tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default. The 
script works with any profile it finds that is firefox based. If the extension .xpi file is already downloaded to /tmp, it won't be downloaded again, saving time. </p1>

<h2> to do - add extension for Secure SNI, make the script work again (isnt working as of today, I believe its due to how firefox based browsers handle extension signing, i am working on a solution) </h2>



<h2> prerequisites </h2>

    sudo apt-get install jq


<h2> Extension List </h2>
<p2>

    
1. **Bitwarden Password Manager**
2. **OpenVideo**
3. **NoScript**
4. **Buster Captcha Solver**
5. **Archive**
6. **Search by Image**
7. **Privacy Possum**
8. **Privacy Badger**
9. **Location Guard**
10. **Flagfox**
11. **Ghostery**
12. **Fake Filler**
13. **DuckDuckGo Privacy Suite**
14. **Disconnect**
15. **Disable WebRTC**
16. **Decentraleyes**
17. **Dark Reader**
18. **ClearURLs**
19. **CanvasBlocker**
20. **User-Agent String Switcher**
21. **AdNauseam**
22. **WhatCampaign**
23. **Violent Monkey**
24. **uBlock Origin**
25. **HackTools**
26. **JavaScript Restrictor**
27. **Hackbar v2**

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


<h3> useful things that im using for ideas, notes to self </h3>
Global addon install

If you want to install an extension automatically to all users in your system you need to extract it, rename the folder that contains the addon to the addon's id string and copy it to the firefox global extensions folder /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/, anything that you use there will be called up automatic when a user opens firefox.
User specific install

If you want to install an extension automatically to just one user in your system you need to extract it, rename the folder that contains the addon to the addon's id string and copy it to the firefox user extensions folder /home/user_name/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/ (create it if it does not exist), anything that you use there will be called up automatic when a user opens firefox.
How-to prepare an addon for automatic install - Example

Make an extensions folder in your home and download the addon in to it

mkdir ~/extensions
cd ~/extensions
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi

Extract it and delete the original

unzip ~/extensions/addon-1865-latest.xpi
rm ~/extensions/addon-1865-latest.xpi

Read the first line in the install.rdf file to get the addon's id (in this case it will be {d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}). and create a folder with that name

mkdir ~/extensions/{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}

Move all the files in your extensions folder into the newly created ~/extensions/{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d} and you are ready to install by moving the {d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d} folder, as described, for a local install or for a global install.
How-to set the default home page

To change your homepage without using the preferences inside firefox you have to edit ~/.mozilla/firefox/*.default/prefs.js (where *.default is a folder inside ~/.mozilla/firefox created for your user) and add this line to the end of it

user_pref("browser.startup.homepage", "http://uptechtalk.com");

or using this command

echo "user_pref("browser.startup.homepage", "http://uptechtalk.com");" >> ~/.mozilla/firefox/*.default/prefs.js

You need to do it after closing firefox or the program will overwrite the setting on exit.

If your user has not used firefox yet and you want to set the homepage for all new users (set homepage globally) use this command

echo "user_pref("browser.startup.homepage", "http://uptechtalk.com");" >> /etc/xul-ext/ubufox.js

