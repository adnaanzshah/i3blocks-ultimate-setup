#!/bin/bash

# Get memory info in MB
read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')

# Calculate percentage
percent=$(( 100 * used / total ))

# Choose color: green (<50%), blue (50-80%), red (>=80%)
if (( percent < 50 )); then
    color="#44ff44"
elif (( percent < 80 )); then
    color="#44aaff"
else
    color="#ff4444"
fi

# Format used and total for display
if (( total >= 1024 )); then
    used_disp=$(awk "BEGIN {printf \"%.1f\", $used/1024}")
    total_disp=$(awk "BEGIN {printf \"%.1f\", $total/1024}")
    echo "[$percent%] $used_disp GB / $total_disp GB"
else
    echo "[$percent%] $used MB / $total MB"
fi

echo
echo "$color"