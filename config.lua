local colors = require 'colors'
local fonts = require 'fonts'
local key_tables = require 'key_tables'
local keys = require 'keys'
local mouse_bindings = require 'mouse_bindings'
local ssh_domains = require 'ssh_domains'

local config = {
  adjust_window_size_when_changing_font_size = true,
  automatically_reload_config = true,
  cell_width = 1.0,
  check_for_updates = false,
  check_for_updates_interval_seconds = 86400, -- 24 hours
  clean_exit_codes = { 130 },
  color_scheme = 'tissue-dark',
  cursor_thickness = '2px',
  debug_key_events = false,
  default_cursor_style = 'SteadyBlock',
  default_workspace = 'default',
  detect_password_input = true,
  enable_scroll_bar = false,
  enable_tab_bar = true,
  enable_wayland = true,
  hide_tab_bar_if_only_one_tab = true,
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
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
  set_environment_variables = {
    THEME = 'tissue-dark',
  },
  scroll_to_bottom_on_input = true,
  scrollback_lines = 10000,
  show_tab_index_in_tab_bar = true,
  show_update_window = false,
  status_update_interval = 1000,
  switch_to_last_active_tab_when_closing_tab = true,
  tab_and_split_indices_are_zero_based = false,
  tab_bar_at_bottom = true,
  tab_max_width = 15,
  text_background_opacity = 1.0,
  underline_thickness = '2px',
  use_fancy_tab_bar = true,
  window_background_opacity = 1.0,
  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  },
}

local function merge_tables(...)
  local table = {}

  for _, t in ipairs { ... } do
    for k, v in pairs(t) do
      assert(table[k] == nil)
      table[k] = v
    end
  end

  return table
end

return merge_tables(config, colors, fonts, key_tables, keys, mouse_bindings, ssh_domains)
