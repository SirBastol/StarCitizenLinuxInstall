# Star Citizen Linux Install – SirBastol Edition
**One-command install & uninstall · Full logging · 2025-ready**

Fully automated installer for **Star Citizen on Ubuntu (and Debian-based distros)** using the official LUG Helper with extra stability tweaks (8 GB swap, vm.max_map_count, desktop shortcut, etc.).

Tested and working on Ubuntu 22.04 · 24.04 · 24.10+  

GitHub: https://github.com/SirBastol/StarCitizenLinuxInstall

## Features
- One-liner install (curl/wget) — no git clone needed
- Automatic 8 GB swap creation
- Applies `vm.max_map_count=262144` (prevents freezes)
- Full error logging to `install.log`
- Creates proper RSI Launcher desktop entry
- Clean uninstall script (keeps your game files!)
- Easy updates — just re-run the installer

## Quick Install (Recommended – 1 command)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/SirBastol/StarCitizenLinuxInstall/main/install.sh)
```

or with wget:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/SirBastol/StarCitizenLinuxInstall/main/install.sh)
```

That’s it — the script does everything.

## Manual Install (Alternative)

```bash
git clone https://github.com/SirBastol/StarCitizenLinuxInstall.git
cd StarCitizenLinuxInstall
chmod +x install.sh
sudo ./install.sh
```

## Uninstall – Full Clean Removal (keeps your game download!)

### One-liner uninstall (from anywhere)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/SirBastol/StarCitizenLinuxInstall/main/uninstall.sh)
```

### Manual uninstall

```bash
cd StarCitizenLinuxInstall
sudo ./uninstall.sh
```

→ Removes Wine prefix, LUG Helper, swap, desktop entries, sysctl tweak  
→ Your actual Star Citizen install (usually `~/StarCitizen`) is **NOT** deleted

## Updating Star Citizen / Wine / LUG

Just re-run the installer — it will update everything automatically:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/SirBastol/StarCitizenLinuxInstall/main/install.sh)
```

## After Installation

1. Open **RSI Launcher** (search "RSI" in your menu or run `rsi-launcher` in terminal)
2. Log in with your RSI account
3. Click **Install** → **DO NOT change the default Windows path!**
4. Wait for ~100–130 GB download
5. Launch the game and fly!

## Requirements

- Ubuntu or Debian-based distro
- SSD (HDD will crash the game)
- 32 GB RAM minimum (64 GB strongly recommended)
- Good internet connection

## Logs

Everything is logged to:
```
install.log   (created in the folder where you ran the script)
```

## Troubleshooting

- LUG Wiki: https://wiki.starcitizen-lug.org/
- Discord: https://discord.gg/starcitizen-lug
- Check `install.log` if something goes wrong

## Credits

- LUG Helper → https://github.com/starcitizen-lug/lug-helper
- Maintained with love by SirBastol

**Fly safe, citizen. o7**
