--! Not for use in WSL. Won't function properly

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Campbell (Gogh)'


-- config.font_dirs = { '/home/nick/.local/share/fonts' }

config.font = wezterm.font('FiraCode Nerd Font Mono')
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.font_size = 10.0

config.initial_rows = 30
config.initial_cols = 112


config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.default_cursor_style = 'SteadyUnderline'
config.cursor_thickness = '3px'

config.scrollback_lines = 100000
config.enable_scroll_bar = true

config.colors = {
	-- name = "Campbell",
	foreground = "#CCCCCC",
	background = "#000000",
	cursor_bg = "#FFFFFF",
	cursor_fg = "#000000",

	selection_bg = "#FFFFFF",
	selection_fg = '#000000',

	scrollbar_thumb = '#222222',


	ansi = {
		"#000000", --black
		"#C50F1F", --red
		"#13A10E", --green
		"#C19C00", --yellow
		"#0037DA", --blue
		"#881798", --purple
		"#3A96DD", --cyan
		"#CCCCCC", --white
	},
	brights = {
		"#767676", -- brightBlack
		"#E74856", -- brightRed
		"#16C60C", -- brightGreen
		"#F9F1A5", -- brightYellow
		"#3B78FF", -- brightBlue
		"#B4009E", -- brightPurple
		"#61D6D6", -- brightCyan
		"#F2F2F2", -- brightWhite
	},
}


config.keys = {
	{
		key = 'W',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = 'w',
		mods = 'CTRL',
		action = wezterm.action.CloseCurrentPane { confirm = false },
	},
	{
		key = 't',
		mods = 'CTRL',
		action = wezterm.action.SpawnTab "CurrentPaneDomain",
	},
	{
		key = '=',
		mods = 'ALT',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = '-',
		mods = 'ALT',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
	},
	{
		key = 'Tab',
		mods = 'CTRL|SHIFT',
		action = wezterm.action { ActivateTabRelative = -1 },
	},

	{
		key = 'Tab',
		mods = 'CTRL',
		action = wezterm.action { ActivateTabRelative = 1 },
	},
}


return config
