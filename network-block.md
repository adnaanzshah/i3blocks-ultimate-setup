# Network Block

This block keeps you informed about your network connection, showing interface, IP, SSID, and real-time speed in your i3blocks bar.

---

## What Does It Show?

- **Active network interface** (WiFi or Ethernet)
- **Connection name or SSID**
- **IP address**
- **Upload/download speed** (cycles every 5 seconds)
- **Color-coded** by connection type

---

## How It Works

The script detects your default network interface and gathers details using `ip`, `nmcli`, and sysfs statistics. It calculates upload and download speeds by tracking byte counters and cycles through info for a dynamic display.

**Colors** indicate connection type:  
- Green for WiFi  
- Blue for Ethernet  
- Orange for others

---

## Technical Walkthrough

- **Detects default interface**:  
  `ip route | grep '^default' | awk '{print $5}'`
- **Gets connection details**:  
  - Type and name via `nmcli`
  - IP via `ip addr`
- **Calculates speed**:  
  - Reads RX/TX bytes from `/sys/class/net/$IF/statistics/`
  - Computes rate and formats as kB/s or MB/s
- **Cycles display** every 5 seconds

---

## Resource Usage

- **CPU:** ~0.2% (runs once per second)
- **RAM:** <2MB

---

## Example Output
🌐 WiFi: HomeNetwork Speed: 1.2 MB/s #44ff44


---

## Customization

You can adjust cycling intervals, colors, or displayed info in the script.  
See `scripts/network.sh` for more.