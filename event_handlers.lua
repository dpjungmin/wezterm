local wezterm = require 'wezterm'
local action = wezterm.action
local mux = wezterm.mux

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something`
  local args = {}

  if cmd then
    args = cmd.args
  end

  wezterm.log_info(args)
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = ' '
    .. basename(tab.active_pane.foreground_process_name)
    .. ' ['
    .. (tab.tab_index + 1)
    .. '] '

  if tab.is_active then
    return {
      { Text = title },
    }
  end

  local has_unseen_output = false

  for _, pane in ipairs(tab.panes) do
    if pane.has_unseen_output then
      has_unseen_output = true
      break
    end
  end

  if has_unseen_output then
    return {
      { Foreground = { Color = '#e4b55e' } },
      { Text = title },
    }
  end

  return title
end)

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local zoomed = ''

  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''

  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()

  if name then
    name = 'active key table: ' .. name
  end

  window:set_right_status(name or '')
end)

wezterm.on('update-status', function(window, pane)
  local meta = pane:get_metadata() or {}
  local o = window:get_config_overrides() or {}

  if meta.password_input then
    o.color_scheme = 'Red Alert'
  else
    o.color_scheme = nil
  end

  window:set_config_overrides(o)
end)

wezterm.on('window-config-reloaded', function(window, pane)
  -- window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
end)

wezterm.on('window-resized', function(window, pane)
  wezterm.log_info 'window-resized!'
end)

-- Custom events

wezterm.on('toggle-opacity', function(window, pane)
  local o = window:get_config_overrides() or {}

  if not o.window_background_opacity then
    o.window_background_opacity = 0.7
  else
    o.window_background_opacity = nil
  end

  window:toast_notification('wezterm', 'event: toggle-opacity', nil, 4000)
  window:set_config_overrides(o)
end)

wezterm.on('trigger-nvim-with-text', function(window, pane)
  local io = require 'io'
  local os = require 'os'

  local viewport_text = pane:get_lines_as_text()

  local name = os.tmpname()
  local f, errmsg = io.open(name, 'w+')

  if f == nil then
    wezterm.log_error('Failed to open file ' .. name .. ': ' .. errmsg)
    return
  end

  f:write(viewport_text)
  f:flush()
  f:close()

  window:toast_notification('wezterm', 'event: trigger-nvim-with-text', nil, 4000)

  window:perform_action(
    action.SpawnCommandInNewWindow {
      args = { 'nvim', name },
    },
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

wezterm.on('setup-work-env', function(window, pane)
  local o = window:get_config_overrides() or {}

  window:toast_notification('wezterm', 'event: setup-work-env', nil, 4000)
  window:set_config_overrides(o)

  local tab1, pane1, window = mux.spawn_window {
    workspace = 'work',
    cwd = wezterm.home_dir,
    args = args,
  }
  local tab2, pane2, window = window:spawn_tab {}
  local tab2, pane3, window = window:spawn_tab {}

  pane1:send_text 'connect\n'
  pane2:send_text 'connect\n'
  pane3:send_text 'connect\n'

  tab1:activate()
  mux.set_active_workspace 'work'
end)
