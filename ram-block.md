# RAM Block

This block displays real-time memory (RAM) usage in your i3blocks status bar, using color-coding for quick visual feedback.

---

## What Does It Show?

- **Current RAM usage** as a percentage.
- **Used and total memory** (in MB or GB, depending on your system).
- **Color-coded**:  
  - Green for low usage (<50%)  
  - Blue for moderate usage (50–80%)  
  - Red for high usage (≥80%)

---

## How It Works

The script reads memory statistics using the `free` command and processes the output with `awk`. It calculates the percentage of memory used and formats the output for clarity. If your system has more than 1GB RAM, values are shown in GB with one decimal; otherwise, MB is used.

**Color selection** is based on usage percentage, making it easy to spot when your system is under heavy load.

---

## Technical Walkthrough

- **Reads memory info**:  
  `free -m | awk '/^Mem:/ {print $2, $3}'`  
  (Gets total and used memory in MB.)
- **Calculates usage percentage**:  
  `percent=$(( 100 * used / total ))`
- **Chooses color**:  
  - `<50%` → green  
  - `50–80%` → blue  
  - `≥80%` → red
- **Formats output**:  
  - If total ≥ 1024 MB, shows GB (e.g., `3.8 GB / 7.7 GB`)
  - Otherwise, shows MB

---

## Resource Usage

- **CPU:** ~0.1% (runs once per second)
- **RAM:** <1MB

---

## Example Output
[42%] 3.8 GB / 7.7 GB #44aaff


---

## Customization

You can adjust the color thresholds or formatting by editing the script.  
For more details, see the script source in `scripts/ram.sh`.