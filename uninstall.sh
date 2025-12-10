#!/bin/bash
# Star Citizen Linux FULL UNINSTALLER
# https://github.com/SirBastol/StarCitizenLinuxInstall
# Removes Wine prefix, LUG Helper, swap, desktop entries, sysctl tweak — keeps your game download!

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}========================================"
echo -e "  STAR CITIZEN LINUX UNINSTALLER"
echo -e "  This will remove ALL Linux-side setup"
echo -e "  Your ~100+ GB game files will NOT be deleted"
echo -e "=======================================${NC}"
echo
read -p "Type YES to continue: " confirm
[[ "$confirm" != "YES" ]] && echo "Aborted." && exit 0

log() { echo -e "${GREEN}[+] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }

log "Removing RSI Launcher desktop entry..."
rm -f "$HOME/.local/share/applications/rsi-launcher.desktop"
rm -f "$HOME/.local/share/icons/rsi-launcher.png" 2>/dev/null || true
log "Desktop entry removed"

log "Removing LUG Helper directories..."
rm -rf "$HOME/lug-helper" "$HOME/.local/share/lug-helper" 2>/dev/null || true
rm -rf "$(pwd)/lug-helper" 2>/dev/null || true
log "LUG Helper directories removed"

log "Removing Wine prefix (RSI Launcher + Star Citizen runtime)..."
rm -rf "$HOME/.wine-star-citizen" "$HOME/.wineprefixes/star-citizen" 2>/dev/null || true
rm -rf "$HOME/.local/share/wineprefixes/star-citizen" 2>/dev/null || true
log "Wine prefix removed (game download in ~/StarCitizen is SAFE)"

log "Removing StarCitizenLinuxInstall repo (this folder)..."
cd "$(dirname "$0")"
cd ..
rm -rf "$(basename "$(pwd)")"
log "Repo folder deleted"

log "Removing 8 GB swap file (if created by installer)..."
if swapon --show | grep -q "/swapfile"; then
    swapoff /swapfile
    rm -f /swapfile
    sed -i '/\/swapfile/d' /etc/fstab
    log "Swap file removed"
else
    warn "No /swapfile found — skipping"
fi

log "Removing vm.max_map_count tweak..."
sed -i '/vm\.max_map_count/d' /etc/sysctl.conf 2>/dev/null || true
sysctl -p >/dev/null 2>&1 || true
log "Sysctl tweak removed"

log "Removing any leftover LUG/Wine symlinks..."
rm -f "$HOME/.local/bin/rsi-launcher" 2>/dev/null || true
rm -f "$HOME/Desktop/rsi-launcher.desktop" 2>/dev/null || true

echo
echo -e "${GREEN}Uninstallation complete!"
echo -e "Your Star Citizen game files are still in:"
echo -e "   ~/StarCitizen  (or wherever you installed)"
echo -e "You can now do a 100% clean reinstall anytime.${NC}"
echo
echo -e "${YELLOW}Fly safe, citizen. o7${NC}"
