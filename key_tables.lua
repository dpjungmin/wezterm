local action = require('wezterm').action

return {
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
