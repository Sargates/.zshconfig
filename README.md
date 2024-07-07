## Info
This is my zsh terminal configuration, complete with personalized tools, aliases, and OMZ theme. \
Configured to work in both WSL and native Linux with integrated keyboard selection similar to text editors using ZLE. \
Feel free to disect it and scrutinize.


## Important Info
- I **highly** recommend using FiraCode Mono with this config. It includes all the necessary glyphs for the theme in addition to supporting font ligatures. However, your terminal must support font ligatures for those to work (GNOME terminal does not). The FireCode repository can be found [here](https://github.com/tonsky/FiraCode/) and the installation instructions [here](https://github.com/tonsky/FiraCode/wiki/Linux-instructions#manual-installation).
	> With most desktop-oriented distributions, double-clicking each font file in the ttf folder and selecting “Install font” should be enough. \
	*From the installation instructions*
- If you use this, it **will backup**, then overwrite the `.zshrc`, `.gitconfig`, `.tmux.conf`, and `.tmux.conf.local` files in your `$HOME` directory. Dated backups can be found in `$HOME/.zshconfig/.cache/.old`.
- For git, some functions are defaulted to certain values, see [the section on git](#scriptsutilsgitzsh).
- For tmux, I don't use tmux. I really only included a tmux conf for the sake of novelty, feel free to remove the config that comes with this.
- See [the section on ssh](#scriptsutilssshzsh). Automatically adds any ssh keys that aren't already added to the ssh-agent. Works best with OMZ's `ssh` plugin. Probably not the most secure solution to add keys automatically, feel free to disable.
- <!-- Note about `headline.zsh-theme` and long loadtimes between prompts on Windows filesystem -->


## Installation
The install script is located at `install/install.bash`. I know that OMZ uses Bourne shell for their install script, I don't care enough to do that. If your machine can use zsh, it can probably use bash. \
You can run the script remotely using `curl` or `wget` using the following commands:
```bash
# For `curl`
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash)"
# For `wget`
bash -c "$(wget https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash -O -)"
```

While this script isn't system dependent, the install script installs packages automatically using the `apt` command and will only work on debian based systems that support it. Support may come for other package managers, but right now the `apt` command is baked into the install script. Installation will work on other systems, but functionality may be buggy if the correct tools are not installed. See `install/packages.txt` for the list of packages that would be installed automatically.

## Uninstallation
Everything related to this package is contained within the `.zshconfig` folder, however it does also install a few packages directly (assuming you're on debian and the install was successful). These packages aren't associated with this project and are ok to leave, but a list of all installed packages can be found in `.zshconfig/install/packages.txt`.

## Walkthrough
The `themes` and `plugins` directory is used by oh-my-zsh to automatically source prompt themes and plugins. The `install`, `.cache`, `config`, and `scripts` folders are all for this setup.

### Includes External Tools
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [column_ansi](https://github.com/LukeSavefrogs/column_ansi)

### Execution Order
The order of execution is pretty straightforward, `.zshrc` get sourced automatically by zsh, this defines `$ZDOTDIR` as `$HOME/.zshconfig`, `$ZSH` as `$ZDOTDIR/ohmyzsh`, `$ZSH_CUSTOM` as `$HOME/.zshconfig`, and sources the ohmyzsh (OMZ) initialization script located at `$ZSH/.oh-my-zsh`. OMZ sources all `.zsh` files located in `$ZSH_CUSTOM` which in this case will only source `profile.zsh`. Then, `profile.zsh` recursively sources all `.zsh` files in the `$ZDOTDIR/scripts` directory allowing for an organizable way to extend this configuration.

### Useful Scripts
See the [documentation](#documentation) section for more on each script.
- `scritps/kbhelper.zsh` - Integrates text-editor-like prompt selection using the ZLE
- `scripts/symlinks.zsh` - Automatically links files in `$HOME` to their respective file in `configs`. Makes a backup of any files that would be overwriten, can be found in `.cache/.old`.
- `scripts/utils/ssh.zsh` - Script to automatically add ssh identities to the ssh agent, works best with OMZ's `ssh-agent` plugin.
- `configs/.gitconfig` - Custom git aliases for custom logging or for specific functionality


## Documentation

### `scripts/kbhelper.zsh`
This is a script that uses the ZSH line editor to introduce baked in text selection similar to something like notepad or gedit. The ZLE can be very confusing and the only good resources I found were [this article](https://thevaluable.dev/zsh-line-editor-configuration-mouseless/) and [the documentation](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html). \
I got the code from stackoverflow (see source for credits) and plan on improving it eventually as I finally got around to learning how it actually works. Essentially, it defines a "widget" as a callback function and then binds that callback to a keysequence in the terminal. The correct keysequences might vary depending on your terminal, use either the "Verbatim Insert" keystrok, normally Ctrl + V (`^V`), or run `showkey -a` and hit certain key combinations to see what bytesequence the terminal is receiving. In the future, I may add some interactive program that will prompt the user for certain keycombinations to cache them and use that for the bindings.

### `scripts/path.zsh`
This script just adds specific things to $PATH and prevents the addition of duplicates

### `scripts/symlinks.zsh`

### `.gitconfig`
- `git log` aliases
  - These aliases are meant to be the default for `git log`. I got them from [here](https://stackoverflow.com/a/9074343) and modified them as I wanted. I prefer `git lg1` so I aliased that to `git lg`.
  - `lg = lg1`
  - `lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'`
    - The spaces in the middle are necessary for the commit message to be evenly spaced
  - `lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all`
- Utility Aliases
  - `root = rev-parse --show-toplevel` - Usage: `git root`. Used to show the root directory of the repository. Purely functional
  - `whatadded = lg --diff-filter=A` - Used to show which commit added a file
  - `whattouched = lg --diff-filter=M` - Used to show which commits edited a file. "`whattouched`" might seem weird, feel free to change.

### `scripts/utils/git.zsh`
The aliases and commands defined in here pair well with the `git` plugin from ohmyzsh (defined as `plugins` in `.zshrc`).
- `grset [remote] [url]` - `git remote set-url [remote] [url]`
  - A custom defined function that takes in two parameters, `remote` and `url`, to either set the url of a current remote repo or add it if it doesnt exist already.
  - Notice the `unalias` call right before, this is to undo the alias defined by OMZ in the `git` plugin. This is redirected to `/dev/null` to silence the warning if `grset` is not defined when called.
- `grget [remote]` - `git remote get-url [remote]`
- `gl` - `git lg` - See [.gitconfig](#gitconfig)
- `gl` - `git lg --all` - Useful for including remote branches and stashed changes
- `gmff` - `git merge --ff-only`
- `gmnff` - `git merge --no-ff`
- `glgrep`
  - Used to search for a regex pattern on `git log`. Used for when you don't want to search through commits manually to find that one change you made.
- `github [repository|user] [repository]` - Used to construct the `ssh` address for pulling from github. Wrap in \`\` to execute inline. Ex: ``` git clone `github Sargates .zshconfig` ```
- `gitlab [repository|user] [repository]` - Exactly the same thing as `github`, but use `sed` to replace `github` with `gitlab`

### `scripts/utils/ssh.zsh`
Probably not the most secure solution to add keys automatically, feel free to disable. See source code [here](./scripts/utils/ssh.zsh).

<!-- ### `scripts/utils/*.zsh` -->