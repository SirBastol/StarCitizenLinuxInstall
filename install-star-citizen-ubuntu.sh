#!/bin/bash

# Star Citizen Linux Installer for Ubuntu (2025 Update)
# Based on: https://www.youtube.com/watch?v=JaFMLMP_L90
# Automates LUG Helper setup for easy installation.
# Run as: sudo ./install-star-citizen-ubuntu.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Star Citizen Linux Installer (Ubuntu) ===${NC}"
echo "This script sets up LUG Helper to install Star Citizen."
echo "Ensure you're on an SSD with 32+ GB RAM. Press Ctrl+C to cancel."
read -p "Continue? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "Aborted." && exit 1

# Step 1: Update system and install prerequisites
echo -e "\n${YELLOW}Step 1: Updating system and installing prerequisites...${NC}"
apt update -y
apt install -y git cabextract unzip wget curl

# Step 2: Set up 8 GB swap (recommended to avoid crashes)
echo -e "\n${YELLOW}Step 2: Setting up 8 GB swap (if not present)...${NC}"
SWAP_FILE="/swapfile"
if [[ ! -f "$SWAP_FILE" ]]; then
    echo "Creating 8 GB swap file..."
    fallocate -l 8G "$SWAP_FILE"
    chmod 600 "$SWAP_FILE"
    mkswap "$SWAP_FILE"
    swapon "$SWAP_FILE"
    echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
    echo -e "${GREEN}Swap created and enabled.${NC}"
else
    echo "Swap already exists. Skipping."
fi

# Step 3: Clone and run LUG Helper
echo -e "\n${YELLOW}Step 3: Cloning and running LUG Helper...${NC}"
if [[ -d "lug-helper" ]]; then
    echo "LUG Helper directory exists. Removing and recloning..."
    rm -rf lug-helper
fi
git clone https://github.com/starcitizen-lug/lug-helper.git
cd lug-helper
chmod +x lug-helper.sh

echo -e "\n${GREEN}Running LUG Helper (interactive - follow prompts!)${NC}"
echo "It will run pre-flight checks, download Wine/RSI Launcher, and set up the environment."
echo "Read the wiki when prompted: https://wiki.starcitizen-lug.org/"
./lug-helper.sh

# Step 4: Ensure desktop entry for RSI Launcher (fallback if LUG Helper doesn't create it)
echo -e "\n${YELLOW}Step 4: Setting up desktop entry for RSI Launcher...${NC}"
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
RSI_DESKTOP="$DESKTOP_DIR/rsi-launcher.desktop"

if [[ ! -f "$RSI_DESKTOP" ]]; then
    cat > "$RSI_DESKTOP" << EOF
[Desktop Entry]
Name=RSI Launcher (Star Citizen)
Exec=rsi-launcher
Icon=rsi-launcher
Type=Application
Categories=Game;
Comment=Launch Star Citizen via RSI
EOF
    chmod +x "$RSI_DESKTOP"
    echo -e "${GREEN}Desktop entry created. Search for 'RSI' in your menu.${NC}"
else
    echo "Desktop entry already exists. Skipping."
fi

# Step 5: Post-install instructions
echo -e "\n${GREEN}=== Installation Complete! ===${NC}"
echo ""
echo "Next steps (from the video):"
echo "1. Launch RSI Launcher:"
echo "   - GUI: Search 'RSI' in your app menu."
echo "   - Terminal: rsi-launcher"
echo ""
echo "2. In RSI Launcher:"
echo "   - Log in with your RSI account."
echo "   - Click 'Install' (use DEFAULT Windows install path - DO NOT CHANGE)."
echo "   - Wait for download (~100 GB)."
echo ""
echo "3. Launch the game:"
echo "   - In RSI Launcher, click 'Launch Game'."
echo "   - Wait for queue/login, then play in Persistent Universe or Arena Commander."
echo ""
echo "Troubleshooting:"
echo "   - Check LUG wiki: https://wiki.starcitizen-lug.org/"
echo "   - Ensure vm.max_map_count=262144: echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf && sudo sysctl -p"
echo "   - If issues: Join Star Citizen LUG Discord for help."
echo ""
echo -e "${YELLOW}Enjoy Star Citizen on Linux!${NC}"

cd ~  # Return to home dir
