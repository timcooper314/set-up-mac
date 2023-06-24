#!/usr/bin/env bash

# Original Source:
#  Hacked up version of this gist: https://gist.github.com/codeinthehole/26b37efa67041e1307db
#  and Rob's repo: https://github.com/jarvisrob/set-up-mac

printf "Starting bootstrapping\n"
printf "Running script using bash version: $BASH_VERSION"

readarray PACKAGES < < <(grep -v '^#' < ./brew-packages)
readarray CASKS < <(grep -v '^#' < ./brew-casks)
readarray FONTS < <(grep -v '^#' < ./brew-fonts)
readarray VSCODE_EXTENSIONS < <(grep -v '^#' < ./vscode-extensions)

# Make my directories
echo "Making my directories under HOME (~), i.e. under $HOME"
mkdir ~/bin
#mkdir ~/iso
#mkdir ~/lab
#mkdir ~/tmp
#mkdir ~/vm-share
mkdir ~/code
mkdir ~/.config
echo "Directory structure under $HOME is now:"
ls -d */

# SSH keys
#echo "Generating SSH keys"
#echo "You will be prompted for email, file location (enter for default) and passphrase"
#read -p "Enter SSH key email: " SSH_EMAIL
#ssh-keygen -t rsa -b 4096 -C "$SSH_EMAIL"
#echo "Adding SSH private key to ssh-agent and storing passphrase in keychain"
#echo "You will be prompted for the passphrase again"
#eval "$(ssh-agent -s)"
#cat <<EOT >> ~/.ssh/config
#Host *
#	AddKeysToAgent yes
#	UseKeychain yes
#	IdentityFile ~/.ssh/id_rsa
#EOT
#ssh-add -K ~/.ssh/id_rsa
#read -p "Copy key details and then press <return> to continue"

# Install Homebrew itself
echo "Installing Homebrew ..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"
brew update
brew upgrade
echo "Done ..."

# Disable Brew Analytics
brew analytics off

# Homebrew taps
brew tap aws/tap
#brew tap hashicorp/tap
brew tap homebrew/cask-fonts

printf "Installing packages...\n"
brew install ${PACKAGES[@]}

printf "Installing cask apps...\n\n"
brew install --cask ${CASKS[@]}

printf "Installing fonts...\n"
brew install --cask ${FONTS[@]}

printf "Cleaning up Brew...\n\n"
brew cleanup -s
rm -rf "$(brew --cache)"

# Bash
echo 'You will be prompted for root password to add the new version of bash to /etc/shells'
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells 1>/dev/null

# Zsh
echo 'You will be prompted for root password to add the new version of zsh to /etc/shells'
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells 1>/dev/null
# Create a `.zsh` directory to store our plugins in one place
mkdir -p ~/.zsh

# Dot files
# References:
#   - https://www.davidculley.com/dotfiles/
#   - https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980

echo "Downloading dot files..."
# .aliases
echo "Downloading .aliases"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.aliases -P ~

# .profile
echo "Downloading .profile"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.profile -P ~

# .bashrc
echo "Downloading .bashrc"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.bashrc -P ~

# .bash_profile
echo "Downloading .bash_profile"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.bash_profile -P ~

# .zprofile
echo "Downloading .bash_profile"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.zprofile -P ~

echo "Downloading .zshrc"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.zshrc -P ~

echo "Downloading .hyper.js"
wget https://raw.githubusercontent.com/timcooper314/set-up-mac/master/.hyper.js -P ~

# Download history config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/history.zsh -P ~/.zsh

# Download key bindings config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/key-bindings.zsh -P ~/.zsh

# Download completion config
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/completion.zsh -P ~/.zsh

# VS Code extensions
for ext in "${VSCODE_EXTENSIONS[@]}"; do
   code --install-extension "$ext"
done

# Pycharm/IntelliJ theme
wget https://raw.githubusercontent.com/JordanForeman/idea-snazzy/master/snazzy.icls -P ~

#sudo gem install colorls

# Configure Git
echo "Configuring Git settings and aliases ..."
read -p "Enter global default Git email: " GIT_EMAIL

# Configure Git settings
git config --global user.name "Tim Cooper"
git config --global user.email "$GIT_EMAIL"
#git config --global core.editor "code"
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
#defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
#defaults write com.apple.finder QuitMenuItem -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles true

# Show status bar (# of items and disk space)
defaults write com.apple.finder ShowStatusBar true

# Show path bar
defaults write com.apple.finder ShowPathbar true

killall -HUP Finder

echo "Dock settings"

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
#defaults write com.apple.dock static-only -bool true

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
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"

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
