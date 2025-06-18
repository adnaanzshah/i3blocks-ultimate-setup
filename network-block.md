# Network Block

A minimal, dynamic i3blocks module that keeps you updated on your network connection, interface, IP, SSID, and real-time speed.

---

## What This Block Shows

- **Active network interface** (WiFi or Ethernet)
- **Connection name or SSID**
- **IP address**
- **Upload/download speed** (cycles every 5 seconds)
- **Color-coded** by connection type

---

## How It Works

- Detects your default network interface.
- Gets connection details using `ip`, `nmcli`, and sysfs.
- Calculates upload/download speed from byte counters.
- Cycles through SSID, IP, and speed every 5 seconds.
- Chooses color based on connection type.

---

## Example Output

```
🌐 WiFi: HomeNetwork
Speed: 1.2 MB/s
#44ff44
```

---

## Resource Usage
- **CPU:** ~0.2% (runs once per second)
- **RAM:** <2MB

---

*For customization, edit `scripts/network.sh`.*