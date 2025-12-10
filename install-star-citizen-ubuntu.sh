#!/bin/bash

# Star Citizen Linux Installer for Ubuntu via SirBastol Repo (2025 Update)
# Based on: https://github.com/SirBastol/StarCitizenLinuxInstall
# Clones the repo and runs its install.sh (custom LUG Helper wrapper).
# Run as: sudo ./install-star-citizen-sirbastol.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Star Citizen Linux Installer (SirBastol Repo) ===${NC}"
echo "This clones https://github.com/SirBastol/StarCitizenLinuxInstall"
echo "and runs its install.sh for automated LUG Helper + Star Citizen setup."
echo "Ensure SSD, 32+ GB RAM. Press Ctrl+C to cancel."
read -p "Continue? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "Aborted." && exit 1

# Step 1: Update system and install prerequisites (repo requires these)
echo -e "\n${YELLOW}Step 1: Updating system and installing prerequisites...${NC}"
apt update -y
apt install -y git cabextract unzip wget curl

# Step 2: Set up 8 GB swap (recommended to avoid crashes, as per LUG best practices)
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

# Step 3: Clone the SirBastol repo and run its install.sh
echo -e "\n${YELLOW}Step 3: Cloning SirBastol repo and running install.sh...${NC}"
if [[ -d "StarCitizenLinuxInstall" ]]; then
    echo "Repo directory exists. Removing and recloning..."
    rm -rf StarCitizenLinuxInstall
fi
git clone https://github.com/SirBastol/StarCitizenLinuxInstall.git
cd StarCitizenLinuxInstall
chmod +x install.sh

echo -e "\n${GREEN}Running SirBastol install.sh (follow any prompts!)${NC}"
echo "It auto-clones LUG Helper, runs pre-flight checks, sets up Wine/RSI Launcher."
echo "Repo tweaks: Auto-accepts defaults, adds vm.max_map_count=262144 for stability."
echo "Read LUG wiki if prompted: https://wiki.starcitizen-lug.org/"
./install.sh

# Step 4: Ensure desktop entry for RSI Launcher (fallback if not created)
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

# Step 5: Verify/apply repo-specific sysctl tweak (if missing)
echo -e "\n${YELLOW}Step 5: Applying vm.max_map_count tweak (Star Citizen requirement)...${NC}"
if ! grep -q "vm.max_map_count=262144" /etc/sysctl.conf; then
    echo "vm.max_map_count=262144" | tee -a /etc/sysctl.conf
    sysctl -p
    echo -e "${GREEN}Sysctl tweak applied.${NC}"
else
    echo "Sysctl tweak already present. Skipping."
fi

# Step 6: Post-install instructions (tailored to repo)
echo -e "\n${GREEN}=== Installation Complete via SirBastol Repo! ===${NC}"
echo ""
echo "Next steps:"
echo "1. Launch RSI Launcher:"
echo "   - GUI: Search 'RSI' in your app menu."
echo "   - Terminal: rsi-launcher"
echo ""
echo "2. In RSI Launcher:"
echo "   - Log in with RSI account."
echo "   - Click 'Install' (use DEFAULT Windows path - DO NOT CHANGE)."
echo "   - Download ~100 GB (takes time)."
echo ""
echo "3. Launch game:"
echo "   - Click 'Launch Game' in RSI."
echo "   - Queue/login, then play PU or Arena Commander."
echo ""
echo "Repo notes:"
echo "   - This uses LUG Helper under the hood — check its logs if issues."
echo "   - For updates: cd StarCitizenLinuxInstall && git pull && ./install.sh"
echo ""
echo "Troubleshooting:"
echo "   - LUG wiki: https://wiki.starcitizen-lug.org/"
echo "   - Star Citizen LUG Discord: https://discord.gg/starcitizen-lug"
echo "   - If pre-flight fails: Ensure SSD, swap enabled, and re-run install.sh."
echo ""
echo -e "${YELLOW}Enjoy Star Citizen on Linux!${NC}"

cd ~  # Return to home dir
