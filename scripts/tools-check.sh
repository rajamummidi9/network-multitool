#!/usr/bin/env bash
# Quick inventory of bundled networking tools.
set -euo pipefail

tools=(
  arping bash curl dig ethtool host ifconfig iperf3 ip jq lsof mtr
  nc netstat nslookup openssl ping socat ss tcpdump tcptraceroute
  telnet traceroute wget
)

echo "Network MultiTool — rajamummidi9"
echo "================================"
for tool in "${tools[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    path=$(command -v "$tool")
    printf "  %-16s %s\n" "$tool" "$path"
  else
    printf "  %-16s (missing)\n" "$tool"
  fi
done
