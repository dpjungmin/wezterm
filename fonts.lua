local wezterm = require 'wezterm'

return {
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
}
