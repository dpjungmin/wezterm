local M = {}
local wezterm = require 'wezterm'

function M.log_info()
  wezterm.log_info('hostname: ' .. wezterm.hostname()) -- heeji.local
  wezterm.log_info('target-triple: ' .. wezterm.target_triple) -- aarch64-apple-darwin
  wezterm.log_info('version: ' .. wezterm.version)
end

function M.merge_tables(...)
  local table = {}

  for _, t in ipairs { ... } do
    for k, v in pairs(t) do
      assert(table[k] == nil)
      table[k] = v
    end
  end

  return table
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function M.basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

return M
