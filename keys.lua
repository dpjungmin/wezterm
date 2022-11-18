local wezterm = require 'wezterm'
local action = wezterm.action

return {
  -- custom key tables
  {
    key = 'r',
    mods = 'LEADER',
    action = action.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = action.ActivateKeyTable {
      name = 'activate_pane',
      timeout_milliseconds = 1000,
    },
  },

  -- custom event
  { key = 'E', mods = 'CTRL', action = action.EmitEvent 'trigger-vim-with-visible-text' },
  { key = 'B', mods = 'CTRL', action = action.EmitEvent 'my-custom-event' },

  -- open custom links
  {
    key = 'g',
    mods = 'META',
    action = wezterm.action_callback(function(window, pane)
      wezterm.open_with 'https://github.com/dpjungmin'
    end),
  },

  -- weztern actions
  { key = 'b', mods = 'CTRL', action = action.RotatePanes 'CounterClockwise' },
  { key = 'n', mods = 'CTRL', action = action.RotatePanes 'Clockwise' },
  { key = 'l', mods = 'CTRL', action = action.ShowDebugOverlay },
  { key = 'z', mods = 'CTRL', action = action.TogglePaneZoomState },

  { key = 'f', mods = 'META', action = action.ToggleFullScreen },
  { key = 'l', mods = 'META', action = action.ShowLauncher },

  { key = 'p', mods = 'LEADER', action = action.PaneSelect { alphabet = '1234567890' } },
  { key = '.', mods = 'LEADER', action = action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = ',', mods = 'LEADER', action = action.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- workspace
  {
    key = '1',
    mods = 'CTRL',
    action = action.SwitchToWorkspace {
      name = 'default',
    },
  },
  {
    key = '2',
    mods = 'CTRL',
    action = action.SwitchToWorkspace {
      name = 'dev',
    },
  },
  {
    key = '3',
    mods = 'CTRL',
    action = action.SwitchToWorkspace {
      name = 'monit',
    },
  },

  -- ex) multiple keys from one key
  {
    key = 'LeftArrow',
    action = action.Multiple {
      action.SendKey { key = 'l' },
      action.SendKey { key = 'e' },
      action.SendKey { key = 'f' },
      action.SendKey { key = 't' },
    },
  },

  -- ex) CMD-y starts `top` in a new tab
  {
    key = 'y',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'top' },
    },
  },
}
