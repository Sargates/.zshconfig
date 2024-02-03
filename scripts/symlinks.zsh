# This file ensures symlinks in `~` exist and point to the files in `configs`

source "$ZSHCFG/scripts/utils/saveAndLink.zsh" # This script uses functions defined in `utils.zsh`

saveAndLink ".zshrc" "$HOME"
for config in $ZSHCFG/configs/*; do
	saveAndLink "configs/${config:t}" "$HOME"
done