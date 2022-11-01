local wezterm = require 'wezterm'

local action = wezterm.action
local hostname = wezterm.hostname()
local target_triple = wezterm.target_triple
local version = wezterm.version

local font_size = 20.0

wezterm.log_info('hostname: ' .. hostname) -- heeji.local
wezterm.log_info('target-triple: ' .. target_triple) -- aarch64-apple-darwin
wezterm.log_info('version: ' .. version)

-- local colors, metadata = wezterm.color.load_scheme(wezterm.config_dir .. '/danqing.toml')

wezterm.on('trigger-vim-with-visible-text', function(window, pane)
  local io = require 'io'
  local os = require 'os'

  local viewport_text = pane:get_lines_as_text()

  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(viewport_text)
  f:flush()
  f:close()

  window:perform_action(
    action.SpawnCommandInNewWindow {
      args = { 'vim', name },
    },
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()

  if name then
    name = 'TABLE: ' .. name
  end

  window:set_right_status(name or '')
end)

return {
  color_scheme = 'tissue',

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

  window_frame = {
    font = wezterm.font { family = 'Roboto', weight = 'Bold' },
    font_size = 12.0,
    active_titlebar_bg = '#2d302f',
    inactive_titlebar_bg = '#2d302f',
  },

  default_prog = { '/opt/homebrew/bin/fish', '-l' },
  hide_tab_bar_if_only_one_tab = false,
  tab_bar_at_bottom = true,
  enable_scroll_bar = true,
  scrollback_lines = 10000,

  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  window_background_opacity = 1.0,
  text_background_opacity = 1.0,

  set_environment_variables = {
    SHELL = '/opt/homebrew/bin/fish',
  },

  launch_menu = {
    {
      label = 'btop',
      args = { 'top' },
    },
  },

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
  font_size = font_size,

  -- leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 2000 },

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
        wezterm.open_with('https://github.com/dpjungmin', 'firefox')
      end),
    },
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
}
