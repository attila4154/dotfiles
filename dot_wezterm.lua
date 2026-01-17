local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.macos_window_background_blur = 10
config.window_background_opacity = 0.93

config.font_size = 16

-- config.color_scheme = "Catppuccin Macchiato"
config.color_scheme = "nord"
-- config.color_scheme = "Kanagawa (Gogh)"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollByLine(-5) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollByLine(5) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

return config
