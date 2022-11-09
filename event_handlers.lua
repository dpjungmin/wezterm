local wezterm = require 'wezterm'
local action = wezterm.action

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()

  if name then
    name = 'TABLE: ' .. name
  end

  window:set_right_status(name or '')
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
