#!/bin/bash

set -e  # Stop on first error

# extensions (list of .xpi download URLs)
EXTENSIONS=(
    "https://addons.mozilla.org/firefox/downloads/file/4348137/bitwarden_password_manager-2024.8.2.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4199397/openvideo-4.2.1.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4349514/noscript-11.4.37.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4297951/buster_captcha_solver-3.1.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4307780/view_page_archive-6.1.1.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4309046/search_by_image-7.1.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3360398/privacy_possum-2019.7.18.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4321653/privacy_badger17-2024.7.17.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3924046/location_guard-2.5.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4345347/flagfox-6.1.78.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4343983/ghostery-10.4.3.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4330661/fake_filler-4.1.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4325805/duckduckgo_for_firefox-2024.7.24.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4240055/disconnect-20.3.1.2.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3551985/happy_bonobo_disable_webrtc-1.0.23.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4255788/decentraleyes-2.0.19.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4341235/darkreader-4.9.89.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4262820/canvasblocker-1.10.1.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4098688/user_agent_string_switcher-0.5.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4328793/adnauseam-3.22.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3617919/whatcampaign-1.0.9.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4315769/violentmonkey-2.20.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4328681/ublock_origin-1.59.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3901885/hacktools-0.4.0.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/4352350/javascript_restrictor-0.19.1.xpi"
    
)

# Trap to clean up in case of an error
trap 'echo "An error occurred. Exiting."; exit 1' ERR


# Function to download and install extensions for a given profile
download_and_install() {
    local profile_dir=$1
    echo "Processing profile: $profile_dir"

    # Ensure the extensions directory exists
    local ext_dir="$profile_dir/extensions"
    if [ ! -d "$ext_dir" ]; then
        echo "Creating extensions directory at $ext_dir"
        mkdir -p "$ext_dir"
    fi

    # Download and install each extension
    for url in "${EXTENSIONS[@]}"; do
        local ext_name=$(basename "$url")
        local ext_path="/tmp/$ext_name"

        # Download the extension if not already downloaded
        if [ ! -f "$ext_path" ]; then
            echo "Downloading $ext_name..."
            wget -q -O "$ext_path" "$url"
            if [ $? -ne 0 ]; then
                echo "Failed to download $ext_name. Skipping."
                continue
            fi
        else
            echo "$ext_name already downloaded, skipping."
        fi

        # Copy the extension to the profile's extensions directory
        echo "Installing $ext_name to $ext_dir"
        cp "$ext_path" "$ext_dir" || { echo "Failed to install $ext_name."; continue; }
    done
}

# Function to find and process profiles in a given directory
process_profiles() {
    local browser_name=$1
    local profile_dir=$2

    echo "Searching for $browser_name profiles in $profile_dir"

    if [ ! -d "$profile_dir" ]; then
        echo "$browser_name profile directory not found at $profile_dir"
        return
    fi

    local profiles_found=false
    for profile in "$profile_dir"/*.default* "$profile_dir"/*.dev-edition*; do
        if [ -d "$profile" ]; then
            profiles_found=true
            download_and_install "$profile"
        fi
    done

    if [ "$profiles_found" = false ]; then
        echo "No valid $browser_name profiles found in $profile_dir"
    fi
}

# Ensure the script is not run as root (which would use the /root home)
if [ "$(id -u)" = "0" ]; then
    echo "Please do not run this script as root or using sudo."
    exit 1
fi

# Define common profile locations using the user's home directory
user_home=$(eval echo "~$(logname)")

browsers=(
    "Firefox:$user_home/.mozilla/firefox"
    "Firefox Developer Edition:$user_home/.mozilla/firefox-developer-edition"
    "Tor Browser:$user_home/tor-browser_en-US/Browser/TorBrowser/Data/Browser"
)

# Process profiles for each browser
for browser in "${browsers[@]}"; do
    IFS=":" read -r name dir <<< "$browser"
    process_profiles "$name" "$dir"
done

echo "Extension installation complete."
