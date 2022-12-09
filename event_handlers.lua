local lib = require 'libw'
local wezterm = require 'wezterm'
local action = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something`
  local args = {}

  if cmd then
    args = cmd.args
  end

  local tab, pane, window = mux.spawn_window {
    workspace = 'monit',
    args = args,
  }

  pane:send_text 'btop\n'
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = ' ' .. lib.basename(tab.active_pane.foreground_process_name) .. ' '

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
      { Background = { Color = 'yellow' } },
      { Foreground = { Color = 'black' } },
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
    window:set_right_status(name)
    return
  end

  local workspace = ' ' .. window:active_workspace() .. ' '

  window:set_right_status(workspace)
end)

wezterm.on('update-status', function(window, pane)
  local meta = pane:get_metadata() or {}
  local overrides = window:get_config_overrides() or {}

  wezterm.log_info(overrides)

  if meta.password_input then
    overrides.color_scheme = 'Red Alert'
  else
    overrides.color_scheme = nil
  end

  window:set_config_overrides(overrides)
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
end)

wezterm.on('window-resized', function(window, pane)
  wezterm.log_info 'window-resized!'
end)

-- Custom events

wezterm.on('my-custom-event', function(window, pane)
  require('lib').log_info()
end)

wezterm.on('trigger-vim-with-visible-text', function(window, pane)
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
