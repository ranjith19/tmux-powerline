#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set-option -g status-interval 5
tmux set-option -g status 2
tmux set-option -g status-style 'fg=colour255,bg=colour235'
tmux set-option -g 'status-format[0]' "#[fg=colour46,bg=colour235]#(${CURRENT_DIR}/scripts/status.sh border)"
tmux set-option -g 'status-format[1]' "#[align=left]#(${CURRENT_DIR}/scripts/status.sh tabs)#[align=right]#(${CURRENT_DIR}/scripts/status.sh uptime)"
tmux set-window-option -g window-status-format ''
tmux set-window-option -g window-status-current-format ''
