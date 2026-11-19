local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('UDEV Gothic 35NF')
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

-- =========================================================
-- Leader
-- =========================================================

-- Ctrl-o を WezTerm の prefix にする
config.leader = {
  key = 'o',
  mods = 'CTRL',
  timeout_milliseconds = 1000,
}

-- =========================================================
-- Helper
-- =========================================================

-- pane を移動したあと、一時的に pane movement mode に入る
local function activate_pane(direction)
  return act.Multiple {
    act.ActivatePaneDirection(direction),
    act.ActivateKeyTable {
      name = 'pane_movement',
      one_shot = false,
      timeout_milliseconds = 1000,
    },
  }
end

-- =========================================================
-- Key bindings
-- =========================================================

config.keys = {
  -- -------------------------------------------------------
  -- WezTerm pane
  -- -------------------------------------------------------

  -- Ctrl-o ^ : 左右に分割
  {
    key = '^',
    mods = 'LEADER',
    action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },

  -- Ctrl-o - : 上下に分割
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },

  -- -------------------------------------------------------
  -- Ctrl-o passthrough
  -- -------------------------------------------------------

  -- Ctrl-o Ctrl-o:
  -- WezTerm の leader を抜けて、terminal に Ctrl-o を送る
  {
    key = 'o',
    mods = 'LEADER|CTRL',
    action = act.SendKey {
      key = 'o',
      mods = 'CTRL',
    },
  },

  -- -------------------------------------------------------
  -- pane movement
  -- -------------------------------------------------------

  -- Ctrl-o + 矢印で pane を移動し、
  -- その後1秒間は矢印だけで連続移動できる
  {
    key = 'RightArrow',
    mods = 'LEADER',
    action = activate_pane 'Right',
  },
  {
    key = 'LeftArrow',
    mods = 'LEADER',
    action = activate_pane 'Left',
  },
  {
    key = 'DownArrow',
    mods = 'LEADER',
    action = activate_pane 'Down',
  },
  {
    key = 'UpArrow',
    mods = 'LEADER',
    action = activate_pane 'Up',
  },

  -- -------------------------------------------------------
  -- Workspace selector
  -- -------------------------------------------------------

  -- tmux の prefix + s に近い操作で workspace を切り替える
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
}

-- =========================================================
-- Key tables
-- =========================================================

-- pane movement mode
--
-- Ctrl-o + 矢印を押したあと、
-- 1秒以内なら矢印だけで pane を連続移動できる
config.key_tables = {
  pane_movement = {
    {
      key = 'RightArrow',
      action = act.ActivatePaneDirection 'Right',
    },
    {
      key = 'LeftArrow',
      action = act.ActivatePaneDirection 'Left',
    },
    {
      key = 'DownArrow',
      action = act.ActivatePaneDirection 'Down',
    },
    {
      key = 'UpArrow',
      action = act.ActivatePaneDirection 'Up',
    },

    -- Esc でも pane movement mode を終了できる
    {
      key = 'Escape',
      action = 'PopKeyTable',
    },
  },
}

return config
