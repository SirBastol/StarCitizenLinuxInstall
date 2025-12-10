#!/bin/bash
# Star Citizen Linux Installer - SirBastol Edition
# https://github.com/SirBastol/StarCitizenLinuxInstall
# One-liner: bash <(curl -fsSL https://raw.githubusercontent.com/SirBastol/StarCitizenLinuxInstall/main/install.sh)

set -eEuo pipefail

# === Logging to install.log in current directory ===
LOG_FILE="$(pwd)/install.log"
exec > >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

echo "=================================================="
echo "Star Citizen Linux Install (SirBastol Edition)"
echo "Started: $(date)"
echo "Log: $LOG_FILE"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[+] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
error() { echo -e "${RED}[ERROR] $1${NC}"; exit 1; }

log "Checking for root (sudo)..."
[[ $EUID -eq 0 ]] || error "Please run with sudo: sudo bash $0"

log "Updating system and installing prerequisites..."
apt update -y >>"$LOG_FILE" 2>&1
apt install -y git cabextract unzip wget curl winetricks >>"$LOG_FILE" 2>&1 || error "Failed to install packages"

log "Setting up 8 GB swap file (prevents crashes)..."
if ! swapon --show | grep -q "/swapfile"; then
    fallocate -l 8G /swapfile >>"$LOG_FILE" 2>&1
    chmod 600 /swapfile
    mkswap /swapfile >>"$LOG_FILE" 2>&1
    swapon /swapfile >>"$LOG_FILE" 2>&1
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab >/dev/null
    log "8 GB swap created and enabled"
else
    warn "Swap already exists — skipping"
fi

log "Applying vm.max_map_count=262144 (critical for stability)..."
if ! grep -q "^vm\.max_map_count" /etc/sysctl.conf 2>/dev/null; then
    echo "vm.max_map_count=262144" >> /etc/sysctl.conf
    sysctl -p >>"$LOG_FILE" 2>&1
    log "vm.max_map_count set to 262144"
else
    warn "vm.max_map_count already configured"
fi

log "Cloning and running official LUG Helper..."
if [[ -d "lug-helper" ]]; then
    rm -rf lug-helper
fi
git clone https://github.com/starcitizen-lug/lug-helper.git >>"$LOG_FILE" 2>&1 || error "Failed to clone LUG Helper"
cd lug-helper
chmod +x lug-helper.sh

log "Launching LUG Helper (follow prompts — this sets up Wine + RSI Launcher)..."
echo -e "${YELLOW}LUG Helper will now run. Read the prompts carefully!${NC}"
echo "Press Enter to continue..."
read -r
./lug-helper.sh || warn "LUG Helper completed (may have non-fatal warnings)"

cd ..

log "Creating RSI Launcher desktop shortcut..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/rsi-launcher.desktop" << EOF
[Desktop Entry]
Name=RSI Launcher (Star Citizen)
Exec=rsi-launcher
Icon=rsi-launcher
Type=Application
Categories=Game;
Comment=Launch Star Citizen on Linux
Terminal=false
EOF
chmod +x "$HOME/.local/share/applications/rsi-launcher.desktop"
log "Desktop entry created — search 'RSI' in your menu"

log "Installation complete!"
echo
echo "=================================================="
echo "NEXT STEPS:"
echo "1. Launch 'RSI Launcher' from your app menu"
echo "2. Log in → Install Star Citizen (use DEFAULT Windows path!)"
echo "3. Download ~100–130 GB → Launch Game → Fly safe o7"
echo
echo "Log saved to: $LOG_FILE"
echo "To update later: just re-run this script"
echo "=================================================="
echo -e "${GREEN}Star Citizen is ready on Linux!${NC}"
