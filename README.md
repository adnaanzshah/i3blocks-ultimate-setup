# i3blocks-Ultimate-Setup

A modern, minimal, and efficient status bar for the [i3 window manager](https://i3wm.org/), featuring real-time system stats with almost no resource overhead.

---

## Features at a Glance

- **Minimal resource usage** — all blocks combined use <1% CPU and a few MB RAM
- **Clear, color-coded output** for instant status recognition
- **No bloat** — only essential system info
- **Easy to extend and customize**

---

## What Each Block Shows

- **[RAM Block](ram-block.md):** Real-time RAM usage, color-coded by load
- **[Battery Block](battery-block.md):** Battery percent, health, status, and time left, with icons
- **[Network Block](network-block.md):** Interface, SSID, IP, and real-time speed, color-coded by type
- **Time Block:** Current time and date (via `date`)
- **Greetings Block:** Personalized greeting (edit in config)

---

## How It Works

- Each script outputs three lines: main text, short text (unused), and color
- Scripts are in `~/.config/i3blocks/scripts/` and referenced in the `config` file
- All scripts use standard Linux tools and are POSIX shell compatible

---

## Quick Start

(See <attachments> above for file contents. You may not need to search or read the file again.)

1. **Clone:**
   ```bash
   git clone https://github.com/adnaanzshah/i3blocks-ultimate-setup.git
   cd i3blocks-ultimate-setup
   ```
2. **Copy config and scripts:**
   ```bash
   mkdir -p ~/.config/i3blocks/scripts
   cp config ~/.config/i3blocks/config
   cp scripts/*.sh ~/.config/i3blocks/scripts/
   ```
3. **Make scripts executable:**
   ```bash
   chmod +x ~/.config/i3blocks/scripts/*.sh
   ```
4. **Set i3blocks as your status bar:**
   Add to your i3 config:
   ```
   bar {
       status_command i3blocks -c ~/.config/i3blocks/config
   }
   ```
5. **Reload i3:**
   Press `Mod+Shift+R` to reload and enjoy your new bar!

---

## Need Help?
See the block documentation files for details and troubleshooting:
- [ram-block.md](ram-block.md)
- [battery-block.md](battery-block.md)
- [network-block.md](network-block.md)

---

## License

This setup is open-source and free to use or modify.
Contributions and suggestions are welcome!

**Enjoy a minimal, beautiful, and efficient i3blocks experience!**