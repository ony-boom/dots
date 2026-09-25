---@module 'hl.meta'

hl.layer_rule({
	name = "vicinae-blur",
	match = { class = "vicinae" },
	blur = true,
	ignore_alpha = 0,
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
	no_blur = true,
	no_shadow = true,
	rounding = 0,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

-- fl studio (bottles/wine): xwayland pointer offset is only zero when the main
-- window fills the screen, so force it fullscreen. title "^FL Studio" avoids the
-- welcome/plugin dialogs.
hl.window_rule({
	name = "fl-studio-fullscreen",
	match = { class = "steam_proton", title = "^FL Studio" },
	fullscreen = true,
})

hl.layer_rule({
	name = "blur-dms",
	match = { namespace = "dms:.*" },
	blur = true,
	ignore_alpha = 0.7,
})

hl.layer_rule({
	name = "grk-layer",
	match = { namespace = "gtk-layer-shell" },
	blur = true,
	ignore_alpha = 0.7,
})
