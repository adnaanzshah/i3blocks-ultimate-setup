#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

SWITCH_INTERVAL=30
INFO_WIDTH=12

# --- Battery info ---
BAT_PATH="/sys/class/power_supply/BAT1"
charge_now=$(<"$BAT_PATH/charge_now")
charge_full=$(<"$BAT_PATH/charge_full")
charge_full_design=$(<"$BAT_PATH/charge_full_design")
status=$(<"$BAT_PATH/status")
percent=$(( 100 * charge_now / charge_full ))
health=$(awk "BEGIN { printf \"%.0f\", ($charge_full / $charge_full_design) * 100 }")

# --- Color and icon ---
if (( percent >= 80 )); then
    color="#44ff44"
elif (( percent >= 30 && percent < 80 )); then
    color="#44aaff"
else
    color="#ff4444"
fi

icon="🔋"
if [[ "$status" == "Charging" ]]; then
    icon="🔌"
elif [[ "$status" == "Full" ]]; then
    icon="✅"
elif [[ "$status" == "Discharging" && $percent -le 15 ]]; then
    icon="⚠️"
fi

# --- Pad/center info ---
center_info() {
    local s="$1"
    local width="$2"
    local len=${#s}
    if (( len == 0 )); then
        s="Estimating"
        len=${#s}
    fi
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

LOG_DIR="/tmp"
LOG_FILE="$LOG_DIR/battery_log_$(date +%Y%m%d)_$USER.txt"
STATE_FILE="/tmp/battery_laststate_$USER"

# --- Handle status change: clear log and state ---
last_status=""
last_percent=""
if [[ -f "$STATE_FILE" ]]; then
    read last_percent last_status < "$STATE_FILE"
fi

if [[ "$status" != "$last_status" ]]; then
    rm -f "$LOG_FILE"
    echo "$percent $status" > "$STATE_FILE"
    echo "$(date +%s) $percent $status" > "$LOG_FILE"
    phase="estimating"
else
    echo "$percent $status" > "$STATE_FILE"
fi

# --- Log only on percent change ---
last_logged_percent=""
if [[ -f "$LOG_FILE" ]]; then
    last_logged_percent=$(tail -n1 "$LOG_FILE" | awk '{print $2}')
fi
if [[ "$percent" != "$last_logged_percent" ]]; then
    echo "$(date +%s) $percent $status" >> "$LOG_FILE"
fi

# --- Read log and determine phase ---
log_lines=($(awk '{print $1":"$2}' "$LOG_FILE"))
num_points=${#log_lines[@]}

# --- Placeholders ---
placeholder_estimating=$(center_info "$(capitalize "estimating")" $INFO_WIDTH)
placeholder_calculating=$(center_info "$(capitalize "calculating")" $INFO_WIDTH)

# --- Time calculation (fixed for charging) ---
calc_time() {
    local n=${#log_lines[@]}
    if (( n < 2 )); then
        echo ""
        return
    fi
    local total_time=0
    local total_percent=0
    for ((i=1; i<n; i++)); do
        local t1=${log_lines[i-1]%:*}
        local p1=${log_lines[i-1]#*:}
        local t2=${log_lines[i]%:*}
        local p2=${log_lines[i]#*:}
        local dt=$(( t2 - t1 ))
        local dp=0
        if [[ "$status" == "Discharging" ]]; then
            dp=$(( p1 - p2 ))
        else
            dp=$(( p2 - p1 ))
        fi
        if (( dp <= 0 )); then continue; fi
        total_time=$(( total_time + dt ))
        total_percent=$(( total_percent + dp ))
    done
    if (( total_percent == 0 )); then
        echo ""
        return
    fi
    # Average seconds per percent
    local avg_sec_per_percent=$(( total_time / total_percent ))
    local remaining=0
    if [[ "$status" == "Discharging" ]]; then
        remaining=$(( percent * avg_sec_per_percent ))
    else
        remaining=$(( (100 - percent) * avg_sec_per_percent ))
    fi
    # Format as H:MM
    local h=$(( remaining / 3600 ))
    local m=$(( (remaining % 3600) / 60 ))
    if (( h > 0 )); then
        printf "%dh%02dm left" "$h" "$m"
    else
        printf "%dmin left" "$m"
    fi
}

# --- Only keep last 3 points, or if 10%+ jump, reset log ---
if (( num_points > 3 )); then
    first_p=${log_lines[0]#*:}
    last_p=${log_lines[-1]#*:}
    diff=$(( first_p > last_p ? first_p - last_p : last_p - first_p ))
    if (( diff >= 10 )); then
        echo "${log_lines[-1]//:/ } $status" > "$LOG_FILE"
        num_points=1
    else
        tail -n3 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
        log_lines=($(awk '{print $1":"$2}' "$LOG_FILE"))
        num_points=${#log_lines[@]}
    fi
fi

# --- Decide what to display ---
cycle=$(( ($(date +%s) / SWITCH_INTERVAL) % 3 ))
if (( cycle == 0 )); then
    info=$(center_info "$(capitalize "$status")" $INFO_WIDTH)
elif (( cycle == 1 )); then
    info=$(center_info "$(capitalize "health:${health}%")" $INFO_WIDTH)
else
    if (( num_points == 1 )); then
        info="$placeholder_estimating"
    elif (( num_points == 2 )); then
        info="$placeholder_calculating"
    else
        time_rem=$(calc_time)
        if [[ -n "$time_rem" ]]; then
            info=$(center_info "$time_rem" $INFO_WIDTH)
        else
            info="$placeholder_calculating"
        fi
    fi
fi

if [[ -z "$info" || "$info" =~ ^[[:space:]]*$ ]]; then
    info="$placeholder_estimating"
fi

echo -e "$icon $percent% $info"
echo
echo "$color"