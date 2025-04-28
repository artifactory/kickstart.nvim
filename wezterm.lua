local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Scrollback configuration
config.scrollback_lines = 10000 -- Adjust number as needed
config.enable_scroll_bar = true

config.term = "xterm-256color"
config.term = "wezterm"
--config.enable_kitty_keyboard = true

-- If you want to customize scroll behavior
config.mouse_bindings = {
	-- Bind Shift+ScrollWheel to scroll by page
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "SHIFT",
		action = wezterm.action.ScrollByPage(1),
	},
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "SHIFT",
		action = wezterm.action.ScrollByPage(-1),
	},
}
-- nvim
-- Set environment variables
config.set_environment_variables = {
	NVIM_APPNAME = "nvim", -- or your config folder name
}

-- Title formatting: disable WezTerm's built-in title to respect terminal escape sequences
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.0,
}

-- Set to false to disable WezTerm's title formatting
config.force_reverse_video_cursor = false

-- Simplify the format-window-title callback
wezterm.on("format-window-title", function(tab)
	-- Return nil to use application-provided title
	-- Or return a string to override the title
	return nil
end)
-- Add custom background command

--[[wezterm.on("user-var-changed", function(window, _, name, value)]]
--[[local overrides = window:get_config_overrides() or {}]]
--[[if name == "background" then]]
--[[if value == "dark" then]]
--[[overrides.colors = { background = "#1a1b26" }]]
--[[elseif value == "light" then]]
--[[overrides.colors = { background = "#f0f0f0" }]]
--[[else]]
--[[overrides.colors = nil]]
--[[end]]
--[[window:set_config_overrides(overrides)]]
--[[end]]
--[[end)]]

-- Add custom command
config.keys = {
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("toggle-background"),
	},
}
local current_theme = "default"
wezterm.on("toggle-background", function(window, _)
	local overrides = window:get_config_overrides() or {}

	-- Cycle through themes
	if current_theme == "default" then
		current_theme = "blue"
		overrides.colors = { background = "#330066" }
		window:toast_notification("WezTerm", "Switched to blue theme", nil)
	elseif current_theme == "blue" then
		current_theme = "green"
		overrides.colors = { background = "#003300" }
		window:toast_notification("WezTerm", "Switched to green theme", nil)
	elseif current_theme == "green" then
		current_theme = "red"
		overrides.colors = { background = "#880e4f" }
		window:toast_notification("WezTerm", "Switched to red theme", nil)
	else
		current_theme = "default"
		overrides.colors = nil
		window:toast_notification("WezTerm", "Reset to default theme", nil)
	end

	window:set_config_overrides(overrides)
end)
return config
