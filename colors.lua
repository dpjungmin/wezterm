local wezterm = require 'wezterm'
local hostname = wezterm.hostname()
local window_frame_font_size = 12.0

if hostname == 'hz' then
  window_frame_font_size = 15.0
end

return {
  colors = {
    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',

    tab_bar = {
      background = '#2a2e33',

      active_tab = {
        fg_color = '#8ac361',
        bg_color = '#2a2e33',
      },

      inactive_tab = {
        fg_color = '#b5b9b6',
        bg_color = '#2a2e33',
      },

      inactive_tab_hover = {
        fg_color = '#f69d50',
        bg_color = '#2a2e33',
      },

      new_tab = {
        fg_color = '#b5b9b6',
        bg_color = '#2a2e33',
      },

      new_tab_hover = {
        fg_color = '#30dff3',
        bg_color = '#2a2e33',
      },
    },
  },

  window_frame = {
    font = wezterm.font { family = 'Lekton Nerd Font', weight = 'Bold' },
    font_size = window_frame_font_size,
    active_titlebar_bg = '#2a2e33',
    inactive_titlebar_bg = '#2a2e33',
  },
}
