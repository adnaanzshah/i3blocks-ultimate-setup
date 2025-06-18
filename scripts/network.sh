#!/bin/bash

INFO_WIDTH=13           # Default fixed width for info field
INFO_CYCLE_SECS=5       # How many seconds before cycling to next info

center_info() {
    local s="$1"
    local width="$2"
    local len=${#s}
    if (( len >= width )); then
        printf "%s" "$s"
    else
        local pad=$(( (width - len) / 2 ))
        local pad_right=$(( width - len - pad ))
        printf "%*s%s%*s" "$pad" "" "$s" "$pad_right" ""
    fi
}

capitalize() {
    local s="$1"
    echo "${s^}"
}

icon="🌐"

# Get default interface
IF=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
if [[ -z $IF ]]; then
    info=$(center_info "No network" $INFO_WIDTH)
    color="#ff4444"
    echo -e "$icon $info"
    echo
    echo "$color"
    exit
fi

TYPE=$(nmcli -t -f DEVICE,TYPE device | grep "^$IF" | cut -d: -f2)
NAME=$(nmcli -t -f DEVICE,CONNECTION device | grep "^$IF" | cut -d: -f2)
IP=$(ip addr show "$IF" | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)

# For speed calculation (show in kB/s or MB/s, not bits)
SPEED_FILE="/tmp/i3blocks_net_speed_$IF"
CUR_RX=$(cat /sys/class/net/$IF/statistics/rx_bytes 2>/dev/null)
CUR_TX=$(cat /sys/class/net/$IF/statistics/tx_bytes 2>/dev/null)
CUR_TIME=$(date +%s)

LAST_RX=0
LAST_TX=0
LAST_TIME=0
if [[ -f "$SPEED_FILE" ]]; then
    read LAST_RX LAST_TX LAST_TIME < "$SPEED_FILE"
fi
echo "$CUR_RX $CUR_TX $CUR_TIME" > "$SPEED_FILE"

RX_RATE=0
TX_RATE=0
if (( LAST_TIME > 0 )); then
    DELTA_TIME=$((CUR_TIME - LAST_TIME))
    if (( DELTA_TIME > 0 )); then
        RX_RATE=$(( (CUR_RX - LAST_RX) / DELTA_TIME ))
        TX_RATE=$(( (CUR_TX - LAST_TX) / DELTA_TIME ))
    fi
fi

# Convert bytes/sec to kB/s or MB/s (1 kB = 1024 bytes, 1 MB = 1024*1024 bytes)
format_speed() {
    local bytes=$1
    if (( bytes >= 1048576 )); then
        printf "%.2fMB/s" "$(echo "$bytes/1048576" | bc -l)"
    elif (( bytes >= 1024 )); then
        printf "%.1fkB/s" "$(echo "$bytes/1024" | bc -l)"
    else
        printf "%dB/s" "$bytes"
    fi
}

RX_HUMAN=$(format_speed $RX_RATE)
TX_HUMAN=$(format_speed $TX_RATE)

# Only update speed display when it changes
STATE_FILE="/tmp/i3blocks_net_last_speed_$IF"
LAST_SHOWN=""
if [[ -f "$STATE_FILE" ]]; then
    read LAST_SHOWN < "$STATE_FILE"
fi

# Compose the speed string (alternate every run)
sec=$(date +%s)
cycle=$(( (sec / INFO_CYCLE_SECS) % 3 ))
speed_cycle=$(( sec % 2 ))
if (( speed_cycle == 0 )); then
    SPEED_STR="Speed: $RX_HUMAN"
else
    SPEED_STR="Speed: $TX_HUMAN"
fi

# Only update if speed string changed
if [[ "$SPEED_STR" != "$LAST_SHOWN" ]]; then
    echo "$SPEED_STR" > "$STATE_FILE"
    SHOW_SPEED="$SPEED_STR"
else
    SHOW_SPEED="$LAST_SHOWN"
fi

if [[ $TYPE == "wifi" ]]; then
    SSID=$(nmcli -t -f DEVICE,SSID,ACTIVE dev wifi | grep "^$IF" | grep ":yes$" | cut -d: -f2)
    # Dynamically set width: max(default, wifi name + 1)
    if [[ -n "$SSID" && ${#SSID} -ge $INFO_WIDTH ]]; then
        DYN_WIDTH=$(( ${#SSID} + 1 ))
    else
        DYN_WIDTH=$INFO_WIDTH
    fi
    if (( cycle == 0 )); then
        info=$(center_info "$SSID" $DYN_WIDTH)
    elif (( cycle == 1 )); then
        info=$(center_info "$IP" $DYN_WIDTH)
    else
        info=$(center_info "$SHOW_SPEED" $DYN_WIDTH)
    fi
    color="#44ff44"
elif [[ $TYPE == "ethernet" ]]; then
    if (( cycle == 0 )); then
        info=$(center_info "$NAME" $INFO_WIDTH)
    elif (( cycle == 1 )); then
        info=$(center_info "$IP" $INFO_WIDTH)
    else
        info=$(center_info "$SHOW_SPEED" $INFO_WIDTH)
    fi
    color="#44aaff"
else
    if (( cycle == 0 )); then
        info=$(center_info "$NAME" $INFO_WIDTH)
    elif (( cycle == 1 )); then
        info=$(center_info "$IP" $INFO_WIDTH)
    else
        info=$(center_info "$SHOW_SPEED" $INFO_WIDTH)
    fi
    color="#ffaa44"
fi

echo -e "$icon $info"
echo
echo "$color"