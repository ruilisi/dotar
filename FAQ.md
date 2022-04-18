# Frequently Asked Questions
## `vim-import-js building failed` when run `SPUpdate`
When `SPUpdate` updates `vim-import-js`, it will try run `npm install -g import-js` and related directory permissions should be ensured to make this step pass.

## `SpaceVim Unknown function: TSOnBufEnter`
* References
  * https://github.com/SpaceVim/SpaceVim/issues/1800
  * https://github.com/SpaceVim/SpaceVim/issues/3221
* Resolution steps
  * Delete cache   rm -rf ~/.cache/vimfiles/.cache
  * Open vim  run `:CheckHealth` check the current vim status, and fix any errors.
  * Install pip for `python3` if not: `curl https://bootstrap.pypa.io/get-pip.py | python3`
  * `pip install neovim`
  * `npm install -g neovim typescript`
  * Run `:UpdateRemotePlugins` in vim and reopen vim

## `nvim-typescript` is not installed successfully when run `:SPUpdate`
* Add `call dein#reinstall(['nvim-typescript'])` to `~/.local/share/nvim/rplugin.vim`, reopen vim and wait for the `nvim-typescript` plugin to install
* Install it manually:
  ```bash
  cd ~/.cache/vimfiles/repos/github.com/mhartington/
  rm -rf nvim-typescript
  git clone https://github.com/mhartington/nvim-typescript
  cd nvim-typescript
  npm config set registry=https://registry.npmjs.com/
  ./install.sh
  ```
