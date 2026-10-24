#!/usr/bin/env bash
# Prints "CPU 0.43 0.56 0.46 | MEM 5.6Gi/62Gi" for the tmux status line.

load=$(uptime | sed 's/.*load average: //')
mem=$(free -h | awk 'NR==2{print $3"/"$2}')

printf 'CPU %s | MEM %s' "$load" "$mem"
