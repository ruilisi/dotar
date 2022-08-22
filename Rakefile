# frozen_string_literal: true

require 'rake'
require 'fileutils'
require 'English'

def macos?
  RUBY_PLATFORM.downcase.include?('darwin')
end

def linux?
  RUBY_PLATFORM.downcase.include?('linux')
end

# this has all the runcoms from this directory.
task :link_files do
  install_files(Dir.glob('git/*')) if want_to_install?('git configs (color, aliases)')
  install_files(Dir.glob('irb/*')) if want_to_install?('irb/pry configs (more colorful)')
  install_files(Dir.glob('ruby/*')) if want_to_install?('rubygems config (faster/no docs)')
  install_files(Dir.glob('ctags/*')) if want_to_install?('ctags config (better js/ruby support)')
  install_files(Dir.glob('tmux/*')) if want_to_install?('tmux config')
  install_files(Dir.glob('vimify/*')) if want_to_install?('vimification of command line tools')
  run %(
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  )
end

desc 'Hook our dotfiles into system-standard positions.'
task install: %i[submodule_init submodules] do
  puts
  puts '======================================================'
  puts 'Welcome to YADR Installation.'
  puts '======================================================'
  puts

  install_homebrew if macos?
  install_rvm_binstubs

  Rake::Task['link_files'].execute
  Rake::Task['install_tools'].execute
  Rake::Task['install_prezto'].execute
  Rake::Task['install_spacevim'].execute
  Rake::Task['install_asdf'].execute
  Rake::Task['install_node_modules'].execute

  install_fonts

  install_term_theme if macos?

  run_bundle_config

  success_msg('installed')
end

task :install_prezto do
  install_prezto if want_to_install?('zsh enhancements & prezto')
end

desc 'install spacevim and related config files'
task :install_spacevim do
  run 'curl -sLf https://spacevim.org/install.sh | sed "s;github.com/SpaceVim;yuancode.co/ruilisi;" | bash'
  install_files(Dir.glob('SpaceVim*'))
end

desc 'Update spacevim'
task :update_spacevim do
  run %(
    cd ~/.SpaceVim
    git remote set-url origin https://yuancode.co/ruilisi/SpaceVim.git
    git pull --rebase
  )
end

desc 'install asdf'
task :install_asdf do
  run 'git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1'
  install_files(Dir.glob('asdf/*')) if want_to_install?('tool version manager asdf')
  run %(
    . $HOME/.asdf/asdf.sh
    asdf plugin-add kubetail https://github.com/janpieper/asdf-kubetail.git
    asdf install
  )
end

desc 'Install tools which are necessary for developers'
task :install_tools do
  if macos?
    run %(
      brew install proxychains-ng
    )
  else
    run %(
      apt install proxychains
    )
  end
end

desc 'Prepare necessary components for spacevim/typescript'
task :prepare_spacevim_typescript do
  run %(
    pip install neovim
    npm install -g neovim typescript
  )
end

task :update do
  Rake::Task['vundle_migration'].execute if needs_migration_to_vundle?
  Rake::Task['install'].execute
  # TODO: for now, we do the same as install. But it would be nice
  # not to clobber zsh files
end

task :sync do
  vundle_path = File.join('vim', 'bundle', 'vundle')
  unless File.exist?(vundle_path)
    run %(
      cd $HOME/.yadr
      git clone https://github.com/gmarik/vundle.git #{vundle_path}
    )
  end
end

task :submodule_init do
  run %( git submodule update --init --recursive ) unless ENV['SKIP_SUBMODULES']
end

desc 'Init and update submodules.'
task :submodules do
  unless ENV['SKIP_SUBMODULES']
    puts '======================================================'
    puts 'Downloading YADR submodules...please wait'
    puts '======================================================'

    run %(
      cd $HOME/.yadr
      git submodule update --recursive
      git clean -df
    )
    puts
  end
end

task default: 'install'

private

def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def number_of_cores
  cores = if macos?
            run %( sysctl -n hw.ncpu )
          else
            run %( nproc )
          end
  puts
  cores.to_i
end

def run_bundle_config
  return unless system('which bundle')

  bundler_jobs = number_of_cores - 1
  puts '======================================================'
  puts 'Configuring Bundlers for parallel gem installation'
  puts '======================================================'
  run %( bundle config --global jobs #{bundler_jobs} )
  puts
end

def install_rvm_binstubs
  puts '======================================================'
  puts 'Installing RVM Bundler support. Never have to type'
  puts 'bundle exec again! Please use bundle --binstubs and RVM'
  puts "will automatically use those bins after cd'ing into dir."
  puts '======================================================'
  run %( chmod +x $rvm_path/hooks/after_cd_bundler )
  puts
end

def install_homebrew
  run %(which brew)
  unless $CHILD_STATUS.success?
    puts '======================================================'
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating Homebrew.'
  puts '======================================================'
  run %(brew update)
  puts
  puts
  puts '======================================================'
  puts 'Installing Homebrew packages...There may be some warnings.'
  puts '======================================================'
  run %(brew install zsh ctags git hub tmux reattach-to-user-namespace ripgrep ghi)
  run %(brew install macvim --with-override-system-vim --with-lua --with-luajit)
  puts
  puts
end

def install_fonts
  puts '======================================================'
  puts 'Installing patched fonts for Powerline/Lightline.'
  puts '======================================================'
  run %( cp -f $HOME/.yadr/fonts/* $HOME/Library/Fonts ) if macos?
  run %( mkdir -p ~/.fonts && cp ~/.yadr/fonts/* ~/.fonts && fc-cache -vf ~/.fonts ) if linux?
  puts
end

def install_term_theme
  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Light.itermcolors' :'Custom Color Presets':'Solarized Light'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" ~/Library/Preferences/com.googlecode.iterm2.plist )

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  unless File.exist?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts '======================================================'
    puts 'To make sure your profile is using the solarized theme'
    puts 'Please check your settings under:'
    puts 'Preferences> Profiles> [your profile]> Colors> Load Preset..'
    puts '======================================================'
    return
  end

  # Ask the user which theme he wants to install
  message = 'Which theme would you like to apply to your iTerm2 profile?'
  color_scheme = ask message, iTerm_available_themes

  return if color_scheme == 'None'

  color_scheme_file = File.join('iTerm2', "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iTerm_profile_list
  message = "I've found #{profiles.size} #{profiles.size > 1 ? 'profiles' : 'profile'} on your iTerm2 configuration, which one would you like to apply the Solarized theme to?"
  profiles << 'All'
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size - 1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iTerm_available_themes
  Dir['iTerm2/*.itermcolors'].map { |value| File.basename(value, '.itermcolors') } << 'None'
end

def iTerm_profile_list
  profiles = []
  begin
    profiles << `/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null`
  end while $CHILD_STATUS.exitstatus == 0
  profiles.pop
  profiles
end

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx + 1}. #{val}" }
    selection = STDIN.gets.chomp
    if (begin
      Float(selection).nil?
    rescue StandardError
      true
    end) || selection.to_i < 0 || selection.to_i > values.size + 1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i - 1
  values[selection]
end

def install_node_modules
  run('command -v yarn && yarn')
end

def install_prezto
  puts
  puts 'Installing Prezto (ZSH Enhancements)...'

  run %( ln -nfs "$HOME/.yadr/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto" )

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  install_files(Dir.glob('zsh/prezto/runcoms/z*'), :symlink)

  puts
  puts "Overriding prezto ~/.zpreztorc with YADR's zpreztorc to enable additional modules..."
  install_files(Dir.glob('zsh/prezto-override/z*'), :symlink)

  puts
  puts 'Creating directories for your customizations'
  run %( mkdir -p $HOME/.zsh.before )
  run %( mkdir -p $HOME/.zsh.after )
  run %( mkdir -p $HOME/.zsh.prompts )

  if (ENV['SHELL']).to_s.include? 'zsh'
    puts 'Zsh is already configured as your shell of choice. Restart your session to load the new settings'
  else
    puts 'Setting zsh as your default shell'
    if File.exist?('/usr/local/bin/zsh')
      if File.readlines('/private/etc/shells').grep('/usr/local/bin/zsh').empty?
        puts 'Adding zsh to standard shell list'
        run %( echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells )
      end
      run %( chsh -s /usr/local/bin/zsh )
    else
      run %( chsh -s /bin/zsh )
    end
  end
end

def want_to_install?(section)
  if ENV['ASK'] == 'true'
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true
  end
end

def install_files(files, method = :symlink)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV['PWD']}/#{f}"
    target = "#{ENV['HOME']}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %( mv "$HOME/.#{file}" "$HOME/.#{file}.backup" )
    end

    if method == :symlink
      run %( ln -nfs "#{source}" "#{target}" )
    else
      run %( cp -f "#{source}" "#{target}" )
    end

    # Temporary solution until we find a way to allow customization
    # This modifies zshrc to load all of yadr's zsh extensions.
    # Eventually yadr's zsh extensions should be ported to prezto modules.
    source_config_code = 'for config_file ($HOME/.yadr/zsh/*.zsh) source $config_file'
    if file == 'zshrc'
      File.open(target, 'a+') do |zshrc|
        zshrc.puts(source_config_code) if zshrc.readlines.grep(/#{Regexp.escape(source_config_code)}/).empty?
      end
    end

    puts '=========================================================='
    puts
  end
end

def needs_migration_to_vundle?
  File.exist? File.join('vim', 'bundle', 'tpope-vim-pathogen')
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = []
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color',
             'Selected Text Color', 'Selection Color']
  values.flatten.each do |entry|
    run %( /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  end

  run %( /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( defaults read com.googlecode.iterm2 )
end

def success_msg(action)
  puts ''
  puts '   _     _           _         '
  puts '  | |   | |         | |        '
  puts '  | |___| |_____  __| | ____   '
  puts '  |_____  (____ |/ _  |/ ___)  '
  puts '   _____| / ___ ( (_| | |      '
  puts "  (_______\_____|\____|_|      "
  puts ''
  puts "YADR has been #{action}. Please restart your terminal and vim."
end
