# Ruilisi dotfiles

[中文文档 Chinese document](/README.CN.md)

## Requirements
* `zsh`, `tmux`, `vim`, `ag` are installed and zsh is set as your login shell:
```sh
chsh -s $(which zsh)
```
* `Python 3` and `pynvim` as some layers(`denite`) can't be loaded if they are missing
```
python3 -m pip install --user --upgrade pynvim
```

## Install

```sh
bash -c "`curl -fsSL https://raw.githubusercontent.com/ruilisi/dotfiles/master/install.sh`"
```

## Shortcuts

#### Tmux
Prefix is defined as `C-A`(`PRE` for short)

**Scroll Mode**

`PRE [`: Enter Scroll Mode
Shortcut | Function |
:-------:|:--------:|
`S-V`      | Select Text       |
`Enter`    | Copy Text         |
`]`        | Paste text copied from scroll mode |

#### Vim
* `<L>`: Short for `<localleader>`, which is `\` in our setup

**Defined by Us**

Shortcut | Function
:-------:|:--------:
`C-v`      | Enter visual mode
`C-x C-v`  | Paste text from system clipboard
`\<L\>tp`  |toggle paste

**Defined by Vim**

Shortcut | Function
:-------:|:--------:
`o`        |insert a new line below
`O`      |insert a new line above
`0`        |go to the beginning of the line
`$`        |go to the end of the line
`v`        |enter character selection mode
`x`        |delete selected content
`V`        |enter line selection mode
`y`       |copy selected content
`p`        |paste copied content
`Ctrl+u`   |page up
`Ctrl+d`   |page down
`:w`       |save file
`:q`       |quit vim
`w`        |move forward one word
`b`        |move back one word
`gg`       |move to the top of the file
`G`      |move to the bottom of the file
`Ctrl+\`   |show(hide) the Buffers
`:/ keyword`|search
`n`        |go to the next content
`N`      |go to the previous content
`[spc] c l`|(un)comment the selected line
`:%s/key1/key2/g`| replae Key1 with Key2

#### Spacevim
Shortcut | Function
:-------:|:--------:
SPC f v d| open configuration file

#### vim && markdown
* Install `prettier`: `yarn global add prettier` or `npm install --global prettier`
* Open vim and enter command: `:SPUPdate`

## Q&A

#### How to edit command line in vim
During editing command line, press `esc` to enter normal mode, then press `C-x C-e` to edit current command line in vim.

#### install iTerm Solarized Colors


YADR will install the Solarized color scheme into iTerm. You can choose Solarized Dark in Profiles => Colors => Load Presets.


#### swap the positions of caps-lock and escape by [Karabiner-Elements](https://pqrs.org/osx/karabiner/index.html).


Escape is the most commonly used key in vim. The old keyboard used to have the Escape as big as `tab`, the worst part of the Apple keyboard is that the `ESC` key is too small. However，we can swap the roles of `ESC` key and `Caps` key to solve these problems. If you keep tapping on the small target in the corners, you woll definitely reduce your efficiency drastically, and maybe you will cause small inijuries to your hands to repeated muscle force.


#### Set a system-level hotkey for iTerm (Keys=>Hotkey)


We recommend using `Cmd-Escape`, which is actually `Cmd-Capslock`(because the roles are interchanged).


#### Select "Use Lion-style full screen" in the General of iTerm.


After this setting, you will get a large screen that can be switched without having to go through the switching space.


#### Cancel Prefer native fullscreen in the Advanced Settings of MacVim.


Lion-style space switching will reduce all efficiency for no reason, just like iTerm.


## If you want to run on the terminal


- Make sure that your terminal has installed the Solarized color scheme!
- If you don't want to use a terminal with solarized color matching, then makr sure you did this: `let g:yadr_using_unsolarized_terminal = 1 `
# in ~/.vimrc.before

- if you want to use an alternavtive color scheme, such as Gruvbox, then do this in your `~/.vimrc.after`:

```
let g:yadr_disable_solarized_enhancements = 1
colorscheme base16-twilight
```




### Upgrade


Upgrade is very simple.


```bash
cd ~/.yadr
git pull --rebase
rake update
```


## What has been included and how do I configure it?

Keep reading to learn more about what YADR has to offer you!


### [Homebrew](http://mxcl.github.com/homebrew/)


Homebrew is a missing OSX package management system, and it will be installed automatically.

We automatically installed some commonly used packages, such as ctags, git, macvim, hub, and RipGrep (‘rg’). Note that our auto-completion plugin requires MacVim to support Lua. The installer knows how to install it, but if you have installed it before, you need to manually delete your previous MacVim.


### ZSH

Think of Zsh as a more awesome Bash, but without much learning costs. It will do automatic spelling correction, grammar highlighting, and more for the command line you write. We have also added many enhancements:


- Vim mode and bash style historical anti-query: `Ctrl-R`
- Insert the result of the previous command: `Ctrl-x,Ctrl-l`
- Fuzzy match-if you type the wrong folder name, tab completion will correct it.
- [fasd](https://github.com/clvv/fasd) ubtegration - Entering `z` will help you semi-automatically match the recently used folders. Tab completion is also tuen on.
- [Prezto - the zsh behind YADR's](http://github.com/sorin-ionescu/prezto)
- [How to add your own ZSH theme](doc/zsh/themes.md)



### Alias

Most of the things we use every day can be done with two to three character aliases. Please modify them yourself:


```
ae # alias edit
ar # alias reload
```


### Git customization:

YADR will take over your ~/.gitconfig, so if you want to store your git username and other settings, please put them in ~/.gitconfig.user

We recommend setting your user information in this file. In addition, you can set your environment variables appropriately in your ~/.secrets.

Shortcut | Alias
:-------:|:--------:
`ga`     |`git add`
`gb`     |`git branch`
`gbc` or `gnb`    |`git checkout -b`
`gbs`    |`git show-branch`
`gc`     |`git commit --verbose`
`gco`    |`git checkout`
`gcp`    |`git cherry-pick --ff`
`gd`     |`git diff`
`gf`     |`git fetch`
`gfc`    |`git clone`
`gfm`    |`git pull`
`gfr`    |`git pull --rebase`
`gl`     |`git log`
`gpc`    |`git push --set-upstream origin "$(git-branch-current 2> /dev/null)"`
`gr`     |`git rebase`
`gra`    |`git rebase --abort`
`grc`    |`git rebase --continue`
`grs`    |`git rebase --skip`
`gsd`    |`git stash drop`
`gsl`    |`git stash list`
`gsp`    |`git stash pop`
`gst`    |`git stash`



##### vim-gitgutter


- `]h` next hunk(change point)
- `[h` previous hunk
- `<Leader>ha` Put the hunk into the state area to save
- `<Leader>hr` Revoke the hunk



### RubyGems


.gemrc is included. No need to enter `gem install whatever --no-ri --no-rdoc`. `--no-ri --no-rdoc` anymore, because it's all done by default.


### Settings of Tmux

`tmux.conf` provides some reasonable default settings for tmux on Mac OS, such as a powerful status bar and VIM keyboard bindings. You can modify the configuration in `~/.tmux.conf.user`.


### Make everything Vim stylized

The provided inputrc and editrc will transform many of your command-line tools-such as mysql and irb-into vim style. And editrc also contains a Ctrl-R reverse history search function, which is very useful in irb, postgres command line, etc.


### Github problems: [ghi gem](https://github.com/stephencelis/ghi)

We included the `ghi` command. Try `ghi list`, and have fun in managing issues using the command line!


## Vim - Which ones are included?


- [navigation - NERDTree, EasyMotion, CtrlP and more](doc/vim/navigation.md)
- [text object - Manipulate Ruby blocks, and more](doc/vim/textobjects.md)
- [modify the code - support of rails, commit, code block, highlight](doc/vim/coding.md)
- [tools - Indentation, paste buffer management, and more](doc/vim/utils.md)
- [usually do not add new command line improvements](doc/vim/enhancements.md)


Some of the most useful commands provided by YADR are listed below. This is not a comprehensive list. If you want to dig out more information, contact a few of them every day, and then start to look at the plugins provided in the above list to learn more.


#### Tmux

C refer to Ctrl
Shortcut | Function
:-------:|:--------:
`h(jkl)` |`←(↓↑→)Move pane`
`C-a c`  |`Craete a new pane`
`C-a s`  |`Split panes up and down`
`C-a v`  |`Split panes left and right`
`C-a x`  |`Kill pane`
`C-a H(JKL)` |`←(↓↑→)Move dividing line`
`C-a ,` |`Switch to Tmux command line mode`
`C-a d` |`Exit Session`
`C-a D` |`Exit Session`
`C-a 1` |`Enter pane 1`

#### Index

#### Code search

#### File index

#### A better way to press keys for common editing commands


- Autocomplete: Ctrl-[SPC]. snipmate code block: Tab。
- Wrap a word with these symbols: `,#` `,"` `,'` `,]` `,)` `,}`。# Is for #{ruby string insertion}. It can also run in Visual mode (thanks @cj). Normally, they do it through something like `ysw#`.
- Change the content of the tag: `Cmd-'`, `Cmd-"`, `Cmd-]`, `Cmd-)` ... You don’t need to be in the tag。(`Alt` in Linux)
- Go to the previous editing position`,.` (just like `'.`) Because `'` is very difficult for the little finger.
- `,ci`To change anything with a pair of quotes/parentheses, etc.



#### Option window, window, split bar


- Use `Cmd-1` to `Cmd-9` to switch to any specific option window(like iTerm and Chrome) - the option window must be set to the display number(`Alt` in Linux)
- `Ctrl-h,l,j,k` - use to move to left、right、top、bottom commpartment. This is still valid when vim and the split bar are together, thanks to `vim-tmux-navigator`。
- `Q` - Only force kill the window.Close window by `wincmd c`, if the same buffer has multiple corresponding windows, or kill the buffer when this is the last corresponding window`bwipeout`。
- `vv` - Vertical separation (`Ctrl-w,v`)
- `ss` - Horizontal separation (`Ctrl-w,s`)
- `,qo` - Open quickfix window (The output of grep will go to this window)
- `,qc` - close quickfix



#### Rails & Ruby


- `,vv` & `,cc` to switch between view and controller-they are the mappings corresponding to :Rcontroller and :Rview. Explore: R family commands can learn more about the fun of rails.vim!
- `,rs` & `,rl` to run rspec or a spec line in iTerm (check the iTerm window for information).
- `,tt` Add `now: true`tag to a block of the spec file, and then test the block by `rspec --tag=now`.
- `,ss` & `,sl` To achieve the same thing, by using `spring rspec`, one can make your Rails specs faster, by caching `Rails env` (must have spring gem installed).


#### Vim Dev


- `,vc` - (Vim command) Copy the command under the cursor and run it. Very useful for testing single-line changes in vimrc.
- `,vr` - (Vim re-documented) Use the current file as a vim file to load the source.

#### zsh function


- ##### tips: $number is the argument
- `secure_source` -source `~/.yadr/zsh/function.zsh` file, let `function.zsh` modify work immediately in current window
- `pp $1` -useage:`pp xx`, grep process by name
- `set_proxy` -set terminal proxy use http proxy
- `set_vagrant_proxy` -set terminal proxy use vagrant http proxy
- `set_ss_proxy` -set terminal proxy use socks proxy
- `unset_proxy` -cancel all proxy
- `post $1 $2` -curl POST with application/json
- `git-set-remote $1` -set project git remote url
- `gem_source_to_taobao` -set ruby gem source to taobao
- `docker_rm_all` -delete all docker images
- `Replace $1 $2` -replcae all text under current path
- `swap $1 $2` -`swap file1 file2`
- `init_db` -init rails project database
- `kexec` -execute k8s pod by regex pod name
- `klog` -show k8s pod log by regex pod name
- `git_tag_delete` -delete gtihub tag
- `git_tag_add` -add gtihub tag
- `dc` -alias of docker-compose




#### some alias define



- you can find detail in `~/.yadr/zsh/aliases.zsh`



#### SpaceVim Interface elements:
The interface elements of SpaceVim start with [SPC] t or [SPC] T. You can view the second-level instructions by pressing the [SPC] key in the vim window. In the same way, press the required second-level instructions and then you can check the three Level instructions to view.

- `SPC t h s` - Show/hide syntax highlighting
- `SPC t n` - Show/hide line number
- `SPC t h h` - Highlight current line
- `SPC T m` - Show/hide the menu bar (no difference is seen)
- `SPC T t` - Show/hide the toolbar (don’t see the difference)
- `SPC [1-9]` - Jump to the specified window
- `SPC f t` - Open file tree
- `SPC p f` - find files in current project
- `SPC f y` - show and copy current file absolute path in the cmdline
- `SPC f S` - save all files
- `SPC f o` - Find current file in file tree
- `SPC f D` - delete a file and the associated buffer with confirmation
- `SPC f p` - search word in current project
- `SPC p /` - fuzzy search for text in current project
- `SPC c l` - toggle comment lines
- `SPC c p` - toggle comment paragraphs

#### Switch Tab:
When multiple files are opened, the files will be listed in the tab bar in the form of Tabs, and you can switch to the Tab with the corresponding serial number via `\[1-9]`.

- `\1` - Open tag 1
- `\2` - Open tag 2
- `\3` - Open tag 3
- `\4` - Open tag 4
- `\5` - Open tag 5
- `\6` - Open tag 6
- `\7` - Open tag 7
- `\8` - Open tag 8
- `\9` - Open tag 9



#### File tree:
The file tree is used to display the file directory where the currently opened file is located. `SPC f t/<F3>`-Open the file tree

#### Shortcut keys in the file tree:

- `i` - Split a new window vertically and jump
- `gi` - Split a new window vertically without jumping
- `s` - Split a new window horizontally and jump
- `gs` - Split a new window horizontally without jumping
- `t` - Open a new window in a new tab and jump
- `T` - Open a new window in a new tab without jumping
- `o` - Open the currently selected file or directory and jump
- `go` - Open the currently selected file or directory without jumping



#### vim cursor operation:

- `k` - Move cursor up
- `j` - Move cursor down
- `h` - Move cursor left
- `l` - Move cursor right
- `gg` - Move to top of the file
- `G` - Move to bottom of the file
- `[Ctrl] g` - Show current cursor position
- `[Num] G` - Cursor to the specified line
- `0` - Cursor to the beginning of the line
- `[Num] w` - Move the cursor to the beginning of the specified number of words
- `[Num] e` - Move the cursor to the end of the specified number of words



#### vim mode switch:
`[Esc]` - Exit current mode
`i` - Insert mode
`v` - Select mode
`R` - Replace mode


#### Document operation:

- `q` - quit
- `w` - save
- `wq` - save & quit
- `q!` - foce quit



#### Document editing:

- `y` - Copy selected area
- `yy` - Copy entire line
- `p` - Paste


- `o` - Insert a row below
- `O` - Insert a row above
- `A` - End of line insertion
- `a` - Insert to the right of the cursor
- `i` - Insert to the left of the cursor
- `u` - Undo operation
- `U` - Undo operation by line
- `[Ctrl] R` - Redo
- `x` - Delete selected area
- `dw` - Delete word
- `d$` - Delete to end of line
- `dd` - Delete entire line
- `d[num]w` - Delete the specified number of words
- `r` - Replace a character
- `:s/A/B` - Replace the first A in the line with B
- `:s/A/B/g` - Replace all A in this line with B
- `:[num1,num2]s/A/B/g` - Replace A in the specified line with B
- `:%s/A/B/g` - Replace all A in the current tab with B



#### Document query:

- `:/A` - Find A in the document
- `:/A` - Find A in the document, ignoring case
- `n` - To the next
- `N` - To the previous
- `:nohlsearch` - Cancel highlight
- `:set hls is` - Highlight query results
- `:set ic` - Ignore case
##
## Extend or reload YADR settings

- [Debug vim mapping](doc/vim/keymaps.md)
- [Reload vim settings through ~/.vimrc.after or similar files](doc/vim/override.md)
- [Add your own vim plugin](doc/vim/manage_plugins.md)



## Miscellaneous


- [Special praise and thanks](doc/credits.md)
- [Other recommended tools to improve OSX productivity](doc/osx_tools.md)
- [Yan's Blog](http://yanpritzker.com)



### OSX Hacks

The osx file is a bash script with reasonable default settings for developers or high-power users. Read it before running it. use:


```
bin/osx
```

These special skills are centered on Lion. Not necessarily on other OSs. My favorite modules include:


- Extremely fast repeated keystroke speed (now you can achieve fast scrolling through j/k)
- No disk mirror verification (downloaded files open faster)
- Display the contents of the ~/Library folder in the finder (hidden in Lion)



### Macvim has trouble with Lua?


```
brew uninstall macvim
brew remove macvim
brew cleanup
brew install macvim --custom-icons --with-override-system-vim --with-lua --with-luajit
```


### Terminal Vim has trouble with Lua?


Installing a terminal Vim (together with lua) through Ruby managed by RVM will cause a segfault on the neocomplete plugin. Try to uninstall vim, and then use system ruby to uninstall vim:

```
brew uninstall vim
rvm system do brew install vim --with-lua
```


### [Pry](http://pry.github.com/)


Pry provides a better IRB that uses colors, tab completion, and other more tricks out of the box. You can also install [pry-nav](https://github.com/nixme/pry-nav) as a real debugger.

[Learn more about YADR's pry customization and how to install](doc/pry.md)

## Language support
#### Typescript
fix SpaceVim Unknown function: TSOnBufEnter
* References
  * https://github.com/SpaceVim/SpaceVim/issues/1800
  * https://github.com/SpaceVim/SpaceVim/issues/3221
* Resolution steps
  * Delete cache   rm -rf ~/.cache/vimfiles/.cache
  * Open vim  run `:CheckHealth` check the current vim status, and fix any errors.
  * Reopen vim and run `:UpdateRemotePlugins`
  * If it still doesn't work, add `call dein#reinstall(['nvim-typescript'])` to `~/.local/share/nvim/rplugin.vim`, reopen vim and wait for the `nvim-typescript` plugin to install
