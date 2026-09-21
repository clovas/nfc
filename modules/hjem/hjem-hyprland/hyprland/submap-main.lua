local menu = "rofi -show drun"
local terminal = "alacritty"

hl.define_submap("main", function()
  hl.bind("left",  hl.dsp.focus({ direction = "left" }))
  hl.bind("right", hl.dsp.focus({ direction = "right" }))
  hl.bind("up",    hl.dsp.focus({ direction = "up" }))
  hl.bind("down",  hl.dsp.focus({ direction = "down" }))
  hl.bind("H", hl.dsp.focus({ direction = "left" }))
  hl.bind("L", hl.dsp.focus({ direction = "right" }))
  hl.bind("K", hl.dsp.focus({ direction = "up" }))
  hl.bind("J", hl.dsp.focus({ direction = "down" }))

  hl.bind("SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
  hl.bind("SHIFT + right", hl.dsp.window.move({ direction = "right" }))
  hl.bind("SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
  hl.bind("SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
  hl.bind("SHIFT + H", hl.dsp.window.move({ direction = "left" }))
  hl.bind("SHIFT + L", hl.dsp.window.move({ direction = "right" }))
  hl.bind("SHIFT + K", hl.dsp.window.move({ direction = "up" }))
  hl.bind("SHIFT + J", hl.dsp.window.move({ direction = "down" }))

  for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(key, hl.dsp.focus({ workspace = i }))
    hl.bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  end

  hl.bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
  hl.bind("mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
  hl.bind("TAB",        hl.dsp.focus({ workspace = "e+1" }))
  hl.bind("SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

  hl.bind("T", hl.dsp.exec_cmd(terminal))
  hl.bind("F", hl.dsp.window.fullscreen(0))
  hl.bind("C", hl.dsp.window.close())
  hl.bind("K", hl.dsp.window.kill())
  hl.bind("R", hl.dsp.exec_cmd(menu))
  hl.bind("S", hl.dsp.exec_cmd("wl-kbptr"))
  hl.bind("M", function()
      hl.dispatch(hl.dsp.submap("reset"))
      hl.config({ cursor = { inactive_timeout = 0, hide_on_key_press = false } })
      hl.dispatch(hl.dsp.submap("cursor"))
  end)
  hl.bind("SPACE", hl.dsp.submap("reset"), { release = true, transparent = true })
  hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)
