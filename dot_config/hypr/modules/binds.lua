---@module 'hl.meta'

local apps = require("modules.apps")
local mod = apps.mod

-- Binds (was bindings.conf). Key format: "MOD + KEY"
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(apps.browser))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + E", hl.dsp.exec_cmd(apps.fileManager))
hl.bind(mod .. " + SHIFT + V", hl.dsp.window.float())
hl.bind(mod .. " + R", hl.dsp.exec_cmd(apps.menu))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- keeps bar/gaps
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) -- covers bar
hl.bind(mod .. " + V", hl.dsp.exec_cmd(apps.clipboard))
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot -d ~/Pictures/Screenshots"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot-annotate")) -- same capture, opens satty to draw on it
hl.bind("CTRL + ALT + E", hl.dsp.exec_cmd(apps.emoji))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("dms ipc powermenu toggle"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))

-- Move window / move focus (arrows)
for _, d in ipairs({ "left", "right", "up", "down" }) do
	hl.bind(mod .. " + SHIFT + " .. d, hl.dsp.window.move({ direction = d }))
	hl.bind(mod .. " + " .. d, hl.dsp.focus({ direction = d }))
end

-- Workspaces 1..10
for i = 1, 10 do
	local key = tostring(i % 10)
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag (bindm). Drag = move, resize is its own dispatcher; needs mouse flag.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia: bindel = locked + repeating, bindl = locked
local locked = { locked = true }
local locked_rep = { locked = true, repeating = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), locked_rep)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), locked_rep)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked_rep)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked_rep)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), locked_rep)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), locked_rep)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
