# Battery Block

A smart, minimal i3blocks module that shows your battery's real-time status, health, and time remaining, with dynamic cycling and color-coded icons.

---

## What This Block Shows

- **Battery percentage**
- **Charging/discharging status**
- **Battery health** (compares current full charge to design capacity)
- **Estimated time remaining** (to full or empty)
- **Color-coded and icon-enhanced** for quick recognition

---

## How It Works

- Reads battery data from `/sys/class/power_supply/BAT*`.
- Calculates percentage and health.
- Logs recent changes to estimate time remaining.
- Cycles between status, health, and time every 30 seconds.
- Chooses color and icon based on status and level.

---

## Example Output

```
🔋 78% | 3h 12m left
#44aaff
```

---

## Resource Usage
- **CPU:** ~0.1% (runs once per second)
- **RAM:** <1MB

---

*For customization, edit `scripts/battery.sh`.*