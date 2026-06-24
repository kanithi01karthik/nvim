-- WezTerm API entry point.
local wezterm = require("wezterm")

-- Base config table with schema-aware defaults.
local config = wezterm.config_builder()
config.window_close_confirmation = "NeverPrompt"
-- Use zsh as the login shell.
config.default_prog = { "zsh", "-l" }
config.set_environment_variables = {
	NVIM_NOTTYFAST = "1",
}

-- UI: typography scale.
config.font_size = 14

-- UI: font family selection.
config.font = wezterm.font("JetBrains Mono")

-- UI: theme selection.
config.color_scheme = "Osaka Jade"

-- Keys: leader chord is Alt+S.
config.leader = { key = "s", mods = "ALT", timeout_milliseconds = 1000 }

-- Keys: split panes using leader + WASD.
config.keys = {
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.SplitPane({ direction = "Up", size = { Percent = 50 } }),
	},
	{
		key = "a",
		mods = "LEADER",
		action = wezterm.action.SplitPane({ direction = "Left", size = { Percent = 50 } }),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 50 } }),
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 } }),
	},
	{
		key = "Backspace",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{ key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Next") },
	{ key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Prev") },
}
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "NONE",
		action = wezterm.action.Nop,
	},
}

-- UI: pane split border color.
config.colors = {
	split = "#3b3b3b",
}

-- UI: hide the tab bar.
config.enable_tab_bar = false

-- UI: remove native window decorations.
config.window_decorations = "NONE"

--UI: transperancy
config.window_background_opacity = 0.8

--UI: border configuration

local border_color = "#ffffff"

config.window_frame = {
	border_left_width = "1px",
	border_right_width = "1px",
	border_top_height = "1px",
	border_bottom_height = "1px",

	border_left_color = border_color,
	border_right_color = border_color,
	border_top_color = border_color,
	border_bottom_color = border_color,
}

--UI border offset

config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.default_cursor_style = "BlinkingBar"
config.send_composed_key_when_right_alt_is_pressed = false
config.use_dead_keys = false
config.use_ime = false
-- Return the built configuration.
return config
