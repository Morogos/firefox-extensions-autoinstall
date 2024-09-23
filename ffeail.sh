#!/bin/bash

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

# Function to download and install extensions for a given profile
download_and_install() {
    PROFILE_DIR=$1
    echo "Installing extensions for profile: $PROFILE_DIR"
    
    # Check if the extensions directory exists, if not, create it
    if [ ! -d "$PROFILE_DIR/extensions" ]; then
        echo "Creating extensions directory in $PROFILE_DIR"
        mkdir -p "$PROFILE_DIR/extensions"
    fi

    # Download and copy extensions
    for EXTENSION_URL in "${EXTENSIONS[@]}"; do
        EXTENSION_NAME=$(basename "$EXTENSION_URL")
        EXTENSION_PATH="/tmp/$EXTENSION_NAME"
        
        # Download the extension if it doesn't already exist
        if [ ! -f "$EXTENSION_PATH" ]; then
            wget -O "$EXTENSION_PATH" "$EXTENSION_URL"
        fi
        
        # Copy the extension to the profile's extensions directory
        cp "$EXTENSION_PATH" "$PROFILE_DIR/extensions/"
    done
}

# Function to find and process all Firefox-based browser profiles
process_profiles() {
    BROWSER_NAME=$1
    PROFILE_DIR=$2
    
    echo "Looking for profiles in $PROFILE_DIR"
    
    # Find all profiles within the given directory
    if [ -d "$PROFILE_DIR" ]; then
        for PROFILE in "$PROFILE_DIR"/*.default*; do
            if [ -d "$PROFILE" ]; then
                download_and_install "$PROFILE"
            else
                echo "No profile directories found in $PROFILE_DIR"
            fi
        done
    else
        echo "$BROWSER_NAME profile directory not found."
    fi
}

# Process profiles for various Firefox-based browsers
process_profiles "Firefox" "$HOME/.mozilla/firefox"
process_profiles "Firefox Developer Edition" "$HOME/.mozilla/firefox-developer-edition"
process_profiles "Tor Browser" "$HOME/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default"

echo "Extension installation complete."
