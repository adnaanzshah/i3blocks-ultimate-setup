# RAM Block

A minimal, efficient i3blocks module that displays your system's real-time memory usage with clear color-coded feedback.

---

## What This Block Shows

- **Current RAM usage** as a percentage
- **Used and total memory** (in MB or GB)
- **Color-coded status**:
  - Green: <50% usage
  - Blue: 50–80% usage
  - Red: ≥80% usage

---

## How It Works

- Reads memory stats using `free -m` and `awk`.
- Calculates usage percentage.
- Chooses color based on usage.
- Displays values in GB if total RAM ≥ 1GB, otherwise MB.

---

## Example Output

```
[42%] 3.8 GB / 7.7 GB
#44aaff
```

---

## Resource Usage
- **CPU:** ~0.1% (runs once per second)
- **RAM:** <1MB

---

*For customization, edit `scripts/ram.sh`.*