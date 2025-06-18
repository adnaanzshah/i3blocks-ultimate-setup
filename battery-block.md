# Battery Block

This block provides a comprehensive view of your battery status, health, and time remaining, all in your i3blocks bar.

---

## What Does It Show?

- **Battery percentage**
- **Charging/discharging status**
- **Battery health** (compares current full charge to design capacity)
- **Estimated time remaining** (to full or empty)
- **Color-coded and icon-enhanced** for quick recognition

---

## How It Works

The script reads battery data from `/sys/class/power_supply/BAT*` and logs recent changes to estimate time remaining. It cycles through different info (status, health, time) every 30 seconds for a dynamic display.

**Icons** change based on status (charging, full, low, etc.), and colors indicate battery level.

---

## Technical Walkthrough

- **Reads battery info**:  
  - `charge_now`, `charge_full`, `charge_full_design`, `status`
- **Calculates**:  
  - Percentage: `100 * charge_now / charge_full`
  - Health: `(charge_full / charge_full_design) * 100`
- **Logs changes** to estimate time remaining
- **Cycles display** every 30 seconds
- **Chooses color**:  
  - Green (≥80%)  
  - Blue (30–79%)  
  - Red (<30%)

---

## Resource Usage

- **CPU:** ~0.1% (runs once per second)
- **RAM:** <1MB

---

## Example Output
🔋 78% | 3h 12m left #44aaff


---

## Customization

You can change icons, colors, or cycling interval by editing the script.  
See `scripts/battery.sh` for details.