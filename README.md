# tmux-powerline

A minimal, colorful tmux status bar. It shows clickable window tabs with a
stable random color per window, the current tmux session uptime, and a thin
neon-green separator above the status row.

## Install with TPM

Add the plugin to `~/.tmux.conf` before TPM is loaded:

```tmux
set -g @plugin 'ranjith19/tmux-powerline'
```

Install it with `prefix` + `I`, then reload tmux with `prefix` + `r`.

The plugin requires tmux 3.2 or later and a Nerd Font for the powerline
separator glyphs.

## Behavior

- Windows receive a random color from a curated palette when first displayed.
- Their color is stored as a tmux window option, so it remains stable until the
  tmux server stops or the option is removed.
- The active window uses darker, bold text and a filled-circle indicator.
- The right side displays the elapsed lifetime of the active tmux session.
