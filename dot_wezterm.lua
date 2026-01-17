local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
config.use_fancy_tab_bar = false

config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

return config
