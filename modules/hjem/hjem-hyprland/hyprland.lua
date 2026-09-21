local handle = io.popen("ls " .. os.getenv("HOME") .. "/.config/hypr/hyprland/*.lua 2>/dev/null")
if handle then
  for file in handle:lines() do
    local mod = file:match(".+/hypr/(.+)%.lua$"):gsub("/", ".")
    require(mod)
  end
  handle:close()
end
