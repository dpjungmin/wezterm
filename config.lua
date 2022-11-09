local wezterm = require 'wezterm'
local action = wezterm.action

return {
  adjust_window_size_when_changing_font_size = true,
  automatically_reload_config = true,

  cell_width = 1.0,

  check_for_updates = true,
  check_for_updates_interval_seconds = 86400, -- 24 hours

  clean_exit_codes = { 130 },

  colors = {
    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',

    tab_bar = {
      inactive_tab_edge = '#575757',
    },
  },
  color_scheme = 'tissue',

  cursor_thickness = '2px',

  debug_key_events = true,

  default_cursor_style = 'SteadyBlock',
  default_prog = { '/opt/homebrew/bin/fish', '-l' },
  default_workspace = 'dev',

  detect_password_input = true,

  enable_scroll_bar = true,
  enable_tab_bar = true,
  enable_wayland = true,

  font = wezterm.font_with_fallback {
    {
      family = 'Lekton Nerd Font',
      weight = 'Medium',
      stretch = 'Normal',
      harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    },
    'JetBrains Mono',
    'DengXian',
  },
  font_size = 20.0,

  hide_tab_bar_if_only_one_tab = false,

  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },

  key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = 'LeftArrow', action = action.AdjustPaneSize { 'Left', 1 } },
      { key = 'h', action = action.AdjustPaneSize { 'Left', 1 } },

      { key = 'RightArrow', action = action.AdjustPaneSize { 'Right', 1 } },
      { key = 'l', action = action.AdjustPaneSize { 'Right', 1 } },

      { key = 'UpArrow', action = action.AdjustPaneSize { 'Up', 1 } },
      { key = 'k', action = action.AdjustPaneSize { 'Up', 1 } },

      { key = 'DownArrow', action = action.AdjustPaneSize { 'Down', 1 } },
      { key = 'j', action = action.AdjustPaneSize { 'Down', 1 } },

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
      { key = 'LeftArrow', action = action.ActivatePaneDirection 'Left' },
      { key = 'h', action = action.ActivatePaneDirection 'Left' },

      { key = 'RightArrow', action = action.ActivatePaneDirection 'Right' },
      { key = 'l', action = action.ActivatePaneDirection 'Right' },

      { key = 'UpArrow', action = action.ActivatePaneDirection 'Up' },
      { key = 'k', action = action.ActivatePaneDirection 'Up' },

      { key = 'DownArrow', action = action.ActivatePaneDirection 'Down' },
      { key = 'j', action = action.ActivatePaneDirection 'Down' },
    },
  },
  keys = {
    -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
    -- mode until we cancel that mode.
    {
      key = 'r',
      mods = 'LEADER',
      action = action.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
      },
    },

    -- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
    -- mode until we press some other key or until 1 second (1000ms)
    -- of time elapses
    {
      key = 'a',
      mods = 'LEADER',
      action = action.ActivateKeyTable {
        name = 'activate_pane',
        timeout_milliseconds = 1000,
      },
    },

    {
      key = 'E',
      mods = 'CTRL',
      action = action.EmitEvent 'trigger-vim-with-visible-text',
    },

    {
      key = 'g',
      mods = 'META',
      action = wezterm.action_callback(function(window, pane)
        wezterm.open_with 'https://github.com/dpjungmin'
      end),
    },
  },

  launch_menu = {
    {
      label = 'top',
      args = { 'top' },
    },
  },

  line_height = 1.0,

  max_fps = 60,

  pane_focus_follows_mouse = true,

  scroll_to_bottom_on_input = true,

  scrollback_lines = 10000,

  set_environment_variables = {
    SHELL = '/opt/homebrew/bin/fish',
  },

  show_tab_index_in_tab_bar = true,
  show_update_window = true,

  status_update_interval = 1000,

  switch_to_last_active_tab_when_closing_tab = true,

  tab_and_split_indices_are_zero_based = false,
  tab_bar_at_bottom = true,
  tab_max_width = 15,

  text_background_opacity = 0.5,

  underline_thickness = '2px',

  use_fancy_tab_bar = true,

  window_background_opacity = 1.0,
  window_frame = {
    font = wezterm.font { family = 'Roboto', weight = 'Bold' },
    font_size = 12.0,
    active_titlebar_bg = '#2d302f',
    inactive_titlebar_bg = '#2d302f',
  },
  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  },
}
