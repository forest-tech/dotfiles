local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11.0

-- Window
config.window_background_opacity = 0.8
config.window_decorations = 'RESIZE'
config.enable_tab_bar = false

-- Start tmux directly. Detaching tmux will close the WezTerm window.
config.default_prog = {
  '/opt/homebrew/bin/tmux',
  '-f',
  os.getenv('HOME') .. '/.config/tmux/.tmux.conf',
}

-- Iceberg
config.colors = {
  foreground = '#c6c8d1',
  background = '#161821',

  cursor_bg = '#c6c8d1',
  cursor_fg = '#161821',
  cursor_border = '#c6c8d1',

  selection_fg = '#c6c8d1',
  selection_bg = '#272c42',

  ansi = {
    '#1e2132',
    '#e27878',
    '#b4be82',
    '#e2a478',
    '#84a0c6',
    '#a093c7',
    '#89b8c2',
    '#c6c8d1',
  },

  brights = {
    '#6b7089',
    '#e98989',
    '#c0ca8e',
    '#e9b189',
    '#91acd1',
    '#ada0d3',
    '#95c4ce',
    '#d2d4de',
  },
}

return config
