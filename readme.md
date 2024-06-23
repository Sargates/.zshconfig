## Info
This is my terminal config. Complete with personalized tools, aliases, and OMZ theme. \
Configured to work in both WSL and native Linux with integrated keyboard selection similar to browsers and text editors. \
Feel free to disect it and scrutinize.


This configuration is for a zsh terminal.

<!-- ## Requirements
Requires packages to be installed: `zsh`, oh-my-zsh, `git`.
> **:pencil: Note:** For oh-my-zsh, the default directory of `~/oh-my-zsh/` will work, otherwise modify the value of `$ZSH` in `.zshrc` -->

## Installation
The install script is located at `install/install.bash`. I know that OMZ uses Bourne shell for their install script, I don't care enough to do that. If your machine can use zsh, it can probably use bash.

This script is meant for debian based systems as the install script uses the `apt` command. Support may come for other package managers, but right now the `apt` command is baked into the install script. However, this script isn't (I hope) platform dependent so it should work on other distros that don't use `apt`.

## Uninstallation
- Everything related to this script is contained within the `.zshconfig` folder, however it does also install a few packages directly. These packages aren't associated with this project and are ok to leave, but all installed packages can be found in `.zshconfig/install/packages.txt`.

## Documentation (Loose term)
### External Tools
This terminal setup includes different external tools.
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [column_ansi](https://github.com/LukeSavefrogs/column_ansi)

### Directory Structure
The `themes` and `plugins` directory is used by oh-my-zsh to automatically source. The `install`, `.cache`, `config`, and `scripts` folders are all for this setup.



<!-- 
### Automatically installs
- Zsh
- Git
- Python
- Oh-my-zsh
- Xsel && BC package (used for in-terminal selection)
- Included .gitconfig
-->
