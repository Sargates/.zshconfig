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
config.font = wezterm.font('FiraCode Nerd Font Mono')


--config.font = wezterm.font "Fira Code"
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

--print(config.fonts_dir)

-- and finally, return the configuration to wezterm
return config
