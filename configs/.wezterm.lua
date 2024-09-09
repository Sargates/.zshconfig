-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Campbell (Gogh)'

config.font_dirs = { '/home/nick/.local/share/fonts' }
config.font_size = 10.0

config.initial_rows = 30
config.initial_cols = 112

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


config.font = wezterm.font('FiraCode Nerd Font Mono')
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

return config
