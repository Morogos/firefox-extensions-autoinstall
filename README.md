# firefox-extensions-autoinstall
detects any profile directory inside the .mozilla/firefox, .mozilla/firefox-developer-edition, and Tor’s profile directory (tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default. The 
script works with any profile it finds that is firefox based. If the extension .xpi file is already downloaded to /tmp, it won't be downloaded again, saving time.

# to do - add extension for Secure SNI, make the script work again (isnt working as of today, I believe its due to how firefox based browsers handle extension signing, i am working on a solution

# prerequisites

    sudo apt-get install jq


# Extension List

# Use - Linux
Save the Script: ffeail.sh

Make it Executable: chmod +x ffeail.sh

Run: ./ffeail.sh

# Use - Windows (gross, ew, yuck)
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
