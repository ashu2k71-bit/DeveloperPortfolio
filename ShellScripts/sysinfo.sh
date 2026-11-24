#!/usr/bin/env bash
# Author: Ashwani Singh
# Roll number: 2601730361
# Displays a Linux system information report.

set -eu
export LC_ALL=C

printf '===== SYSTEM INFORMATION REPORT =====\n'
printf 'Name: Ashwani Singh\n'
printf 'Roll number: 2601730361\n'
printf 'Date: %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"

cpu_model=$(lscpu | awk -F: '/^Model name:/ {
  sub(/^[[:space:]]+/, "", $2)
  print $2
  exit
}')

case "$cpu_model" in
  ""|"-") cpu_model="Model unavailable in VM ($(uname -m))" ;;
esac

printf 'CPU model: %s\n' "$cpu_model"
printf 'Virtual CPUs available: %s\n\n' "$(nproc)"

free -h | awk '/^Mem:/ {
  print "Total memory: " $2
  print "Used memory:  " $3
}'

printf '\nTop 3 processes by CPU usage\n'
printf '%7s %6s %s\n' 'PID' '%CPU' 'COMMAND'
ps -eo pid=,pcpu=,comm= | sort -k2,2nr | head -3

printf '\nReport generated successfully.\n'
