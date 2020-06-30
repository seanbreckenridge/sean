# dotfiles

This README is is need of a rewrite. Cross platform is *essentially* done.

I use mac less so I have yet to configure it to all of my likings; I primarily use linux, and run a couple apps as a compatability layer on mac:

* window management/keyboard shortcuts
  * Uses [`skhd`](https://github.com/koekeishiya/skhd) as a hot-key daemon to run applications (e.g. `cmd + opt + enter` launches terminal)
  * [amethyst](https://github.com/ianyh/Amethyst) to auto-tile windows a la xmonad
  * `alfred` as a application launcher
* OS-specific bootstrap files in `~/.config/yadm` that check whether I'm on mac/linux, to decide what sort of install/which packages to install.
* `$PATH` is set properly in `zsh`/`X server` startup, update (`zsh` function) respects the OS and updates packages properly.
* Wrapper scripts in `~/.local/scripts/cross-platform` detect platform to send notifications, interact with clipboard etc.

TODO:
  * Write a script to auto-generate keybinds for `i3` (or some other WM) and `skhd`
  * Find a good mac rofi-clone and write a wrapper to pick from user input
  * make these scripts cross-platform:
    * `randomize-wallpaper`
    * `lock-screen`

The rest of the README is for what I used on arch, will be updated into a larger (perhaps wiki) once I have everything setup properly.

- [zsh](http://zsh.sourceforge.net/), plugins/configuration handled manually in [.config/zsh](.config/zsh) (split across multiple files)
- [qtile](https://github.com/qtile?type=source) (primary) and [i3-gaps](https://github.com/Airblader/i3) - window manager
- [yadm](https://yadm.io) to manage dotfiles, see [yadm-with-README.md](.config/yadm/yadm-with-README.md)
- [alacritty](https://github.com/alacritty/alacritty) as terminal 
- [firefox-developer-edition](https://www.archlinux.org/packages/community/x86_64/firefox-developer-edition/) - browser, addons listed in [firefox_addons.txt](./.local/share/firefox_addons.txt)
- [rofi](https://github.com/davatorium/rofi) - application launcher
- [nvim](https://neovim.io/) as sometimes [(doom) emacs](https://github.com/hlissner/doom-emacs) as editors - see [editor](.local/scripts/system/editor)
- [i3lock](https://i3wm.org/i3lock/) for screen lock; [daemon process](.local/scripts/system/lock_screen) caches pixelated version of screen to speed up start time
- [dunst](https://dunst-project.org/) for notifications
- [lightdm](https://wiki.archlinux.org/index.php/LightDM) - display manager
- [todotxt](http://todotxt.org/) for todos, with a [rofi interface](.local/scripts/bin/todo_prompt) as GUI, and [tui](https://gitlab.com/seanbreckenridge/full_todotxt) for adding todos.
- [ranger](https://github.com/ranger/ranger) - file manager
- (in i3) [picom](https://github.com/yshui/picom) for window compositing
- (in i3) [i3blocks](https://github.com/vivien/i3blocks) for status bar

I typically default to dracula-like color schemes to keep things consistent. Currently in use for `qtile`, `alacritty` (terminal), `rofi`, and `emacs`.

[.config/yadm](.config/yadm) includes lists of global packages for pacman/yay, python, ruby, npm, dart, rust, go, and haskell; the zsh [update](.config/zsh/functions/update) function updates all the corresponding packages.

Packages can be added to the `.txt` files manually, and then `yadm bootstrap` can be run repeatedly to make sure everything is installed.

- [.config/shortcuts.toml](.config/shortcuts.toml) - describes basic shell scripts that are created by [shortcuts](https://gitlab.com/seanbreckenridge/shortcuts)
- [dir-aliases](.local/scripts/system/dir-aliases) generates aliases from `key->directory` mappings described in [.config/directories](.config/directories). `dir-aliases-ranger` creates bookmarks in ranger using the same keys.
- [.local/scripts/bin](.local/scripts/bin) - generic scripts
    - media related, [duration](.local/scripts/bin/duration) to get media length, [gifme](.local/scripts/bin/gifme) to convert video to gifs.
    - [gitopen](.local/scripts/bin/gitopen) to open current git directory in browser
    - [qr](.local/scripts/bin/qr) - create a QR code from a string and display it full screen
- [.local/scripts/system](.local/scripts/system) - system related scripts (modifying brightness, volume etc.) w/ [zsh completion](.config/zsh/completions)
- [fzf](https://github.com/junegunn/fzf) **everywhere** - in [ranger](https://gitlab.com/seanbreckenridge/dotfiles/-/blob/master/.config/ranger/commands.py), to search `cwd` recursively and jump to directories (`Alt+C`), to [edit config files](https://gitlab.com/seanbreckenridge/dotfiles/-/blob/c072c474d0ec497761f484d0b11ec555ef397062/.config/shortcuts.toml#L7-15), to kill processes, and to [search the entire system](https://gitlab.com/seanbreckenridge/dotfiles/-/blob/master/.config/zsh/functions/flocate). Integration with [`nvim`](.config/nvim/init.vim) to match against lines/files/commands/buffers.

### Install

    # on mac, run `xcode-select --install`
    yadm clone https://gitlab.com/seanbreckenridge/dotfiles
    # restart the computer so that ~/.profile is sourced by /etc/lightdm/Xsession
    # so OS detection can be done to install the correct packages
    yadm bootstrap

#### LICENSE

Unless where attributed, any customization and scripts are licensed under the MIT License:

```
MIT License

Copyright (c) 2019-20 Sean Breckenridge

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```