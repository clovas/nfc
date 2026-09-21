local mainMod = "SUPER"
local menu = "rofi -show drun"
local terminal = "alacritty"

hl.bind("Print", hl.dsp.exec_cmd("grimblast copysave output /home/saya/Pictures/Screenshots/$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S').png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast copysave area /home/saya/Pictures/Screenshots/$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S').png"))

hl.bind(mainMod .. " + L", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("loginctl lock-session"))
end)
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("uwsm stop"))

hl.bind("CONTROL + SPACE", function()
 -- hl.dispatch(hl.dsp.submap("reset"))
 -- hl.dispatch(hl.dsp.submap("main"))
end)

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
