#!/bin/bash

# Define the extensions to be installed (list of .xpi download URLs)
EXTENSIONS=(
    "https://addons.mozilla.org/firefox/downloads/latest/extension1/addon.xpi"
    "https://addons.mozilla.org/firefox/downloads/latest/extension2/addon.xpi"
)

# Profile directories for Firefox ESR and regular Firefox
FIREFOX_ESR_PROFILE_DIR=~/.mozilla/firefox/0sogym1r.default-esr
FIREFOX_PROFILE_DIR=~/.mozilla/firefox/224uf4t1.default

# Function to download and install extensions
download_and_install() {
    PROFILE_DIR=$1
    echo "Installing extensions for profile: $PROFILE_DIR"
    
    # Check if extensions directory exists, if not, create it
    if [ ! -d "$PROFILE_DIR/extensions" ]; then
        echo "Creating extensions directory in $PROFILE_DIR"
        mkdir "$PROFILE_DIR/extensions"
    fi
    
    # Download and copy extensions
    for EXTENSION_URL in "${EXTENSIONS[@]}"; do
        # Extract the extension name from the URL
        EXTENSION_NAME=$(basename "$EXTENSION_URL")
        
        # Download the extension
        wget -O "/tmp/$EXTENSION_NAME" "$EXTENSION_URL"
        
        # Copy the extension to the profile's extensions directory
        cp "/tmp/$EXTENSION_NAME" "$PROFILE_DIR/extensions/"
    done
}

# Install extensions for Firefox ESR
if [ -d "$FIREFOX_ESR_PROFILE_DIR" ]; then
    download_and_install "$FIREFOX_ESR_PROFILE_DIR"
else
    echo "Firefox ESR profile not found."
fi

# Install extensions for regular Firefox
if [ -d "$FIREFOX_PROFILE_DIR" ]; then
    download_and_install "$FIREFOX_PROFILE_DIR"
else
    echo "Regular Firefox profile not found."
fi

echo "Installation complete."
