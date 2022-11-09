local wezterm = require 'wezterm'
local config = require 'config'

wezterm.log_info('hostname: ' .. wezterm.hostname()) -- heeji.local
wezterm.log_info('target-triple: ' .. wezterm.target_triple) -- aarch64-apple-darwin
wezterm.log_info('version: ' .. wezterm.version)

require 'event_handlers'

local x = {}

for k, v in pairs(x) do
  assert(config[k] == nil)
  config[k] = v
end

return config
