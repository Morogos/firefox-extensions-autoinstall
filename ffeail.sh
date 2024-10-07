#!/bin/bash
set -e  # Stop on first error

# List of extensions (.xpi download URLs)
EXTENSIONS=(
    "https://addons.mozilla.org/firefox/downloads/file/4348137/bitwarden_password_manager-2024.8.2.xpi"
    "https://addons.mozilla.org/firefox/downloads/file/3961037/hackbar_free-2.5.3.xpi"
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

# Function to extract metadata from .xpi (zip) files
extract_metadata() {
    local xpi_file=$1
    local temp_dir=$(mktemp -d)

    # Ensure the temp directory is cleaned up
    trap 'rm -rf "$temp_dir"' EXIT

    unzip -q "$xpi_file" manifest.json -d "$temp_dir"
    local manifest_file="$temp_dir/manifest.json"

    if [ -f "$manifest_file" ]; then
        # Extract extension ID and version from manifest.json
        local extension_id=$(jq -r '.applications.gecko.id // .browser_specific_settings.gecko.id // .name' "$manifest_file")
        local version=$(jq -r '.version' "$manifest_file")
        # If either ID or version is empty, return an error
        if [[ -z "$extension_id" || -z "$version" ]]; then
            echo "Error: Invalid manifest.json in $xpi_file"
            return 1
        fi
    else
        echo "Error: No manifest.json found in $xpi_file"
        return 1
    fi

    echo "$extension_id:$version"
    return 0
}

# Function to update the extensions.json file for the profile
update_extensions_json() {
    local profile_dir=$1
    local ext_id=$2
    local ext_version=$3
    local ext_path=$4
    local ext_json="$profile_dir/extensions.json"

    # Check if the extensions.json file exists, if not, create a basic structure
    if [ ! -f "$ext_json" ]; then
        echo '{"schemaVersion":31, "addons":[]}' > "$ext_json"
    fi

    # Check if the extension is already registered in the extensions.json
    if ! jq -e --arg id "$ext_id" '.addons[] | select(.id == $id)' "$ext_json" > /dev/null; then
        # Add the new extension entry
        jq --arg id "$ext_id" --arg version "$ext_version" --arg path "$ext_path" \
        '.addons += [{"id": $id, "version": $version, "active": true, "path": $path, "type": "extension"}]' "$ext_json" > "${ext_json}.tmp"

        mv "${ext_json}.tmp" "$ext_json"
        echo "Updated $ext_json with extension $ext_id."
    else
        echo "Extension $ext_id is already registered in $ext_json."
    fi
}

# Function to download and install extensions for a given profile
download_and_install() {
    local profile_dir=$1
    echo "Processing profile: $profile_dir"

    # Ensure the extensions directory exists
    local ext_dir="$profile_dir/extensions"
    mkdir -p "$ext_dir"

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
        fi

        # Extract metadata (ID and version) from the downloaded .xpi
        metadata=$(extract_metadata "$ext_path")
        if [ $? -ne 0 ]; then
            echo "Failed to extract metadata from $ext_name. Skipping."
            continue
        fi

        # Split the metadata into extension_id and version
        ext_id=$(echo "$metadata" | cut -d':' -f1)
        ext_version=$(echo "$metadata" | cut -d':' -f2)

        # Copy the extension to the profile's extensions directory
        cp "$ext_path" "$ext_dir/"

        # Update extensions.json with the new extension information
        update_extensions_json "$profile_dir" "$ext_id" "$ext_version" "$ext_dir/$ext_name"
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

# Ensure the script is not run as root (which would use /root home)
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

echo "Extension installation and registration complete."
