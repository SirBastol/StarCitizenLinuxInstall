# StarCitizenLinuxInstall
The script:

Updates your system and installs prerequisites (git, cabextract, unzip).
Optionally sets up 8 GB swap if it doesn't exist (recommended to prevent crashes, as per the video).
Clones and runs the LUG Helper script interactively (it handles Wine setup, pre-flight checks, and RSI Launcher installation).
Creates a desktop entry for easy launching (if not already done by LUG Helper).
Provides post-install instructions for launching the game via the RSI Launcher.

##Important Notes:

Run this on an SSD (required by Star Citizen).
The LUG Helper will prompt you interactively for confirmations—do not skip the wiki read as advised in the video.
Hardware recommendation: At least 32 GB RAM.
This assumes a GUI desktop environment (e.g., GNOME or KDE) for the RSI Launcher desktop entry.
Test on a fresh Ubuntu install (20.04+ works best).

##How to Use This Script

Download and prepare:Bashwget -O install-star-citizen-ubuntu.sh https://example.com/script.sh  # Or copy-paste into a file
chmod +x install-star-citizen-ubuntu.sh
Run it:Bashsudo ./install-star-citizen-ubuntu.sh
After running:
Follow the on-screen prompts in LUG Helper.
The game install will take time (large download).
If you encounter errors (e.g., pre-flight fails), check the wiki or run the sysctl command in the notes.


This script makes the process fully automated where possible while preserving the interactive parts of LUG Helper. If you need tweaks (e.g., non-interactive mode), let me know!2.7s
