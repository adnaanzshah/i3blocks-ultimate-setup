# i3blocks-Ultimate-Setup

Welcome to **i3blocks-Ultimate-Setup** — a thoughtfully crafted, minimal yet feature-rich status bar configuration for the [i3 window manager](https://i3wm.org/). This setup is designed for users who value **minimalism**, **clarity**, and **efficiency**. Every block is engineered to provide essential system information at a glance, while keeping system resource usage exceptionally low.

---

## Why Minimalism?

Our i3blocks configuration is built with minimalism at its core. Each script is lightweight, written in POSIX shell, and avoids unnecessary dependencies. This ensures your system remains fast and responsive, with the status bar consuming only a tiny fraction of your resources — perfect for both modern and older hardware.

---

## How It Works

- **i3blocks** reads the `config` file and executes each block’s script at a set interval.
- Each script outputs three lines:  
  1. **Main text** (displayed in the bar)  
  2. **Short text** (optional, not used here)  
  3. **Color** (for the block background)
- All scripts are located in `~/.config/i3blocks/scripts/` and are optimized for minimal CPU and memory usage.

---

## Block Overview

Below is a summary of each block in this setup.  
Click the block name to view its detailed documentation and technical breakdown.

---

### [Greetings](#greetings-block)
- **Description:** Displays a personalized greeting or your name.
- **Resource Usage:** Negligible (runs only once at startup).
- **[Read More →](#greetings-block)**

---

### [Memory (RAM)](ram-block.md)
- **Description:** Shows real-time RAM usage, color-coded by usage level.
- **Resource Usage:** ~0.1% CPU, <1MB RAM (runs `free` and `awk` once per second).
- **[Read More →](ram-block.md)**

---

### [Battery](battery-block.md)
- **Description:** Displays battery percentage, status (charging/discharging), health, and time remaining, cycling info every 30 seconds.
- **Resource Usage:** ~0.1% CPU, <1MB RAM (reads sysfs and logs minimal data).
- **[Read More →](battery-block.md)**

---

### [Network](network-block.md)
- **Description:** Shows current network interface, IP address, SSID (for WiFi), and real-time upload/download speed, cycling info every 5 seconds.
- **Resource Usage:** ~0.2% CPU, <2MB RAM (reads sysfs and caches speed data).
- **[Read More →](network-block.md)**

---

### [Time](#time-block)
- **Description:** Displays the current time and date in a clear format.
- **Resource Usage:** Negligible (runs `date` once per second).
- **[Read More →](#time-block)**

---

## Minimalism Meets Functionality

- **No bloat:** Only essential information, no unnecessary widgets.
- **Low overhead:** All scripts combined use less than 1% CPU and a few MB of RAM.
- **Easy to extend:** Add or modify blocks as you wish.
- **Modern look:** Color-coded, Unicode icons, and centered text for clarity.

---

## Explore Each Block

- [RAM Block](ram-block.md)
- [Battery Block](battery-block.md)
- [Network Block](network-block.md)

*(Click any link above for a deep dive into how each block works, with line-by-line explanations and customization tips.)*

---

## Getting Started

1. **Clone or copy** this repository to your system.
2. **Symlink or copy** the `config` file to `~/.config/i3blocks/config`.
3. **Ensure scripts are executable**:  
   ```bash
   chmod +x ~/.config/i3blocks/scripts/*.sh
4. **Reload i3 (`Mod+Shift+R`) or restart i3blocks.**

## License

This setup is open-source and free to use or modify.  
Contributions and suggestions are welcome!

**Enjoy a minimal, beautiful, and efficient i3blocks experience!**