#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set-option -g status-interval 5
tmux set-option -g status-style 'fg=colour255,bg=colour235'
tmux set-option -g status-left "#(${CURRENT_DIR}/scripts/status.sh tabs)"
tmux set-option -g status-left-length 200
tmux set-option -g status-right "#(${CURRENT_DIR}/scripts/status.sh uptime)"
tmux set-option -g status-right-length 40
tmux set-window-option -g window-status-format ''
tmux set-window-option -g window-status-current-format ''
