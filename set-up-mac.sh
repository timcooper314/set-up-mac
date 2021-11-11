#!/usr/bin/env bash
echo "Running script using bash version:"
echo $BASH_VERSION
BRANCH=mitch-changes

# This is my set-up, my way
# If you're not me, *really* think before running this script--it's all on you

# Before running, install Xcode command line tools via:
# $ xcode-select —-install

echo "Shell script to set-up a new Mac"
echo "You are warned: This is *my* set-up, *my* way!"
echo "You must also have already installed Xcode command-line tools with: $ xcode-select —-install"

read -p "Press <return> to continue or ^C to quit now"
echo "Here we go ..."

# Make my directories
echo "Making my directories under HOME (~), i.e. under $HOME"
mkdir ~/bin
mkdir ~/iso
mkdir ~/lab
mkdir ~/tmp
mkdir ~/vm-share
mkdir ~/code
echo "Directory structure under HOME (~) is now:"
ls -d */

# Install Homebrew itself
echo "Installing Homebrew ..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"
brew update
brew upgrade
echo "Done ..."

# Disable Brew Analytics
brew analytics off

# We use this from here on
brew install wget

# Dot files
# References:
#   - https://www.davidculley.com/dotfiles/
#   - https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980

echo "Downloading dot files..."
echo "Files downloaded from branch: $BRANCH"

# .aliases
echo "Downloading .aliases"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.aliases -P ~
cat ~/.aliases

# .profile
echo "Downloading .profile"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.profile -P ~
cat ~/.profile

# .bashrc
echo "Downloading .bashrc"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.bashrc -P ~
cat ~/.bashrc

# .bash_profile
echo "Downloading .bash_profile"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.bash_profile -P ~
cat ~/.bash_profile

# .zprofile
echo "Downloading .bash_profile"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.zprofile -P ~
cat ~/.zprofile

echo "Downloading .zshrc"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.zshrc -P ~
cat ~/.zshrc
sudo cat > ~/.zshrc <<EOF
# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"

# Ensure secure connections for brew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export GREP_OPTIONS=' — color=auto'
EOF

echo "Downloading .hyper.js"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.hyper.js -P ~

# .vimrc (Vim)
echo "Downloading .vimrc"
wget https://raw.githubusercontent.com/mitchstockdale/set-up-mac/$BRANCH/.vimrc -P ~
cat ~/.vimrc

# SSH keys
echo "Generating SSH keys"
echo "You will be prompted for email, file location (enter for default) and passphrase"
read -p "Enter SSH key email: " SSH_EMAIL
ssh-keygen -t rsa -b 4096 -C "$SSH_EMAIL"
echo "Adding SSH private key to ssh-agent and storing passphrase in keychain"
echo "You will be prompted for the passphrase again"
eval "$(ssh-agent -s)"
cat <<EOT >> ~/.ssh/config
Host *
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_rsa
EOT
ssh-add -K ~/.ssh/id_rsa
read -p "Copy key details and then press <return> to continue"

# Install packages and software using Homebrew
echo "Installing packages and software using Homebrew ..."

# Bash
echo 'Installing the latest version of bash'
echo 'You will be prompted for root password to add the new version of bash to /etc/shells'
brew install bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells 1>/dev/null

# Zsh
echo 'Installing the latest version of Zsh'
echo 'You will be prompted for root password to add the new version of bash to /etc/shells'
brew install zsh
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells 1>/dev/null

# Create a `.zsh` directory to store our plugins in one place
mkdir -p ~/.zsh

# Download history config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/history.zsh -P ~/.zsh
echo "" >> ~/.zshrc
echo "# Enable 'history' config in ZSH" >> ~/.zshrc
echo "source $HOME/.zsh/history.zsh" >> ~/.zshrc

# Download key bindings config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/key-bindings.zsh -P ~/.zsh
echo "" >> ~/.zshrc
echo "# Enable key bindings in ZSH" >> ~/.zshrc
echo "source $HOME/.zsh/key-bindings.zsh" >> ~/.zshrc

# Download completion config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/completion.zsh -P ~/.zsh
echo "" >> ~/.zshrc
cat <<"EOT" >> ~/.zshrc
# Auto-completion
# Load completion config
source ~/.zsh/completion.zsh

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# Enhanced form of menu completion called 'menu selection'
zmodload -i zsh/complist

# Enable the addition of zsh hook functions
autoload -U add-zsh-hook
EOT

# Terminal tools and commands
brew install bash-completion
brew install tmux
brew install tree
brew install rsync
brew install zsh-syntax-highlighting
echo "" >> ~/.zshrc
echo "# Zsh syntax highlighting" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
brew install zsh-autosuggestions
echo "" >> ~/.zshrc
echo "# Zsh auto-suggestions" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
brew install z
echo "" >> ~/.zshrc
echo "# Allow the use of the z plugin to easily navigate directories" >> ~/.zshrc
echo "source $(brew --prefix)/etc/profile.d/z.sh" >> ~/.zshrc
brew install starship
echo "" >> ~/.zshrc
echo "# Use starship prompt" >> ~/.zshrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
mkdir -p ~/.config && touch ~/.config/starship.toml
cat <<"EOT" >> ~/.config/starship.toml
# Inserts a blank line between shell prompts
add_newline = true

# Replace the "❯" symbol in the prompt with "➜"
[character]                            # The name of the module we are configuring is "character"
success_symbol = "[➜](bold green)"     # The "success_symbol" segment is being set to "➜" with the color "bold green"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true
EOT
echo 'export STARSHIP_CONFIG=~/.config/starship.toml' >> ~/.zshrc


# Dev tools
brew install git
brew install --cask docker
brew install --cask sourcetree

# Terminal
brew install --cask hyper

# Productivity
# brew install --cask microsoft-office, not yet M1 supported
brew install --cask microsoft-edge
# brew install --cask microsoft-teams
brew install --cask zoom
# brew install --cask slack
# brew install --cask alfred
brew install --cask google-chrome
# brew install --cask firefox

# Python (Homebrew version)
# brew install python@3.8

# Pyenv
brew install pyenv
brew install pyenv-virtualenv
echo "" >> ~/.zshrc
echo "# Pyenv" >> ~/.zshrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
echo "" >> ~/.zshrc
echo "# General python" >> ~/.zshrc
echo "export PYTHONDONTWRITEBYTECODE=1" >> ~/.zshrc

# Jenv
brew install jenv
echo "" >> ~/.zshrc
echo "# Jenv" >> ~/.zshrc
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc

# Node.js (required for JupyterLab extensions)
brew install node

# Text editors and IDEs
brew install --cask visual-studio-code
# brew install --cask dbeaver-community
# brew install --cask rstudio
# brew install --cask azure-data-studio
# brew install --cask sublime-text
brew install --cask pycharm-ce
# brew install --cask intellij-idea-ce

# VS Code extensions
code --install-extension piotrpalarz.vscode-gitignore-generator
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension hookyqr.beautify
code --install-extension eamodio.gitlens
code --install-extension ms-python.vscode-pylance
code --install-extension paiqo.databricks-vscode
code --install-extension redhat.vscode-yaml

# Pycharm/IntelliJ theme
wget https://raw.githubusercontent.com/JordanForeman/idea-snazzy/master/snazzy.icls -P ~

# Cloud command-line interfaces and tools
brew install awscli
brew tap aws/tap
brew install aws-sam-cli
brew install azure-cli
# brew install --cask microsoft-azure-storage-explorer

# Visual Analytics / Design
# brew install --cask tableau-public
# brew install --cask tableau
# brew install --cask figma

# SQL
# brew install postgresql
# brew install --cask postgres

# Misc
brew install --cask spotify
# brew install --cask qgis
# brew install --cask postman
brew install --cask drawio

# Mac tools
# brew install --cask scroll-reverser

# Install folder/file icon pack for zsh/hyper
brew tap homebrew/cask-fonts
brew install svn
brew install --cask font-hack-nerd-font
brew install --cask font-fontawesome
brew install --cask font-fira-code
brew install --cask font-roboto
sudo gem install colorls
echo "" >> ~/.zshrc
echo "# colorls tab completion for flags" >> ~/.zshrc
echo "source $(dirname $(gem which colorls))/tab_complete.sh" >> ~/.zshrc

# Homebrew installations complete
brew cleanup
echo "Homebrew software installations complete"

# Configure Git
echo "Configuring Git settings and aliases ..."
read -p "Enter global default Git email: " GIT_EMAIL

# Configure Git settings
git config --global user.name "Mitch Stockdale"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "code"
echo "... Done"

# macOS settings
echo "macOS settings being configured"

echo "First closing System Preferences window if open to avoid conflicts"
# Close System Preferences to prevent conflicts with the settings changes
# The following is AppleScript called from the command line
# http://osxdaily.com/2016/08/19/run-applescript-command-line-macos-osascript/
osascript -e 'tell application "System Preferences" to quit'

echo "Finder settings"

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

killall -HUP Finder

echo "Dock settings"

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
defaults write com.apple.dock static-only -bool true

# Minimise to Dock using "scale" effect
defaults write com.apple.dock mineffect -string scale

defaults write com.apple.dock orientation -string left

defaults write com.apple.dock magnification -bool false

defaults write com.apple.dock show-process-indicators -bool false

defaults write com.apple.dock tilesize -float 40

defaults write com.apple.dock show-recents -bool false

# Don't minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool false

killall Dock

echo ".DS_Store files settings"
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "TextEdit settings"
# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

echo "Screen saver password settings"
# Require password immediately after sleep or screen saver begins
# Start screen saver after 5 mins of idle
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults -currentHost write com.apple.screensaver idleTime 300

echo "Screenshot settings"

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

echo "Dialog settings"
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Make Zsh the default shell
echo 'Making Homebrew installed and updated Zsh the default shell. You will be prompted for root password.'
chsh -s /opt/hombrew/bin/zsh

# End
echo "Mac set-up completed--enjoy!"
echo "Close terminal and re-open to get everything"
echo "It's probably a good idea to reboot now"
echo ""
