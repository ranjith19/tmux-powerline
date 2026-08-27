#!/usr/bin/env bash

set -euo pipefail

readonly BACKGROUND=235
readonly COLOR_OPTION='@tmux_powerline_color'
readonly COLORS=(39 68 71 110 135 141 169 178)

color_is_valid() {
    local color

    for color in "${COLORS[@]}"; do
        [[ "$color" == "$1" ]] && return 0
    done

    return 1
}

color_for_window() {
    local window_id="$1"
    local color candidate
    local available=()

    color="$(tmux show-options -w -v -t "$window_id" "$COLOR_OPTION" 2>/dev/null || true)"
    if ! color_is_valid "$color"; then
        for candidate in "${COLORS[@]}"; do
            [[ " ${used_colors[*]} " == *" $candidate "* ]] || available+=("$candidate")
        done

        # Reuse colors only after every palette entry is assigned.
        ((${#available[@]})) || available=("${COLORS[@]}")
        color="${available[RANDOM % ${#available[@]}]}"
        tmux set-option -w -t "$window_id" "$COLOR_OPTION" "$color"
    fi

    used_colors+=("$color")
    WINDOW_COLOR="$color"
}

print_tabs() {
    local window_id index name active color
    local -a used_colors=()

    while IFS=$'\t' read -r window_id index name active; do
        color_for_window "$window_id"
        color="$WINDOW_COLOR"
        if [[ "$active" == "1" ]]; then
            printf '#[range=window|%s,fg=colour%s,bg=colour%s,bold] ● %s  %s #[fg=colour%s,bg=colour%s]#[norange,nobold]' \
                "$index" "$BACKGROUND" "$color" "$index" "$name" "$color" "$BACKGROUND"
        else
            printf '#[range=window|%s,fg=colour255,bg=colour%s] %s  %s #[fg=colour%s,bg=colour%s]#[norange]' \
                "$index" "$color" "$index" "$name" "$color" "$BACKGROUND"
        fi
    done < <(tmux list-windows -F $'#{window_id}\t#{window_index}\t#{window_name}\t#{window_active}')
}

print_uptime() {
    local created now elapsed days hours minutes

    created="$(tmux display-message -p -F '#{session_created}')"
    now="$(date +%s)"
    elapsed=$((now - created))
    days=$((elapsed / 86400))
    hours=$(((elapsed % 86400) / 3600))
    minutes=$(((elapsed % 3600) / 60))

    if ((days)); then
        printf '#[fg=colour245,bg=colour235]up %dd %02dh' "$days" "$hours"
    else
        printf '#[fg=colour245,bg=colour235]up %02dh %02dm' "$hours" "$minutes"
    fi
}

case "${1:-}" in
tabs)
    print_tabs
    ;;
uptime)
    print_uptime
    ;;
*)
    printf 'usage: %s {tabs|uptime}\n' "$0" >&2
    exit 64
    ;;
esac
