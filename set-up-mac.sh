#!/bin/bash

echo "Shell script to set-up a new Mac"


# Make my directories
echo "Making my directories under HOME (~), i.e. under $HOME"
mkdir ~/bin
mkdir ~/blog
mkdir ~/iso
mkdir ~/lab
mkdir ~/tmp
mkdir ~/vm-share


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


## Install Homebrew itself
echo "Installing Homebrew ..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
echo "Done ..."


## Install packages and software using Homebrew and Conda
echo "Installing packages and software using Homebrew ..."

### Terminal tools and commands
brew cask install iterm2
brew install tmux
brew install tree
brew install wget
brew install rsync

### Dev tools
brew install git
brew cask install docker

### Productivity
brew cask install microsoft-teams
brew cask install alfred
brew cask install google-chrome
brew cask install firefox
brew cask install dropbox

### R

#### XQuartz is required for R packages that use X11, which is no longer installed on macOS
echo "Installing XQuartz. You will be prompted for root password."
brew cask install xquartz

#### R.app is the macOS version of CRAN-R
brew cask install r-app

#### Linking the BLAS, vecLib, from Apple's Accelerate Framework to make R run multi-threaded where it can by default
#### https://developer.apple.com/documentation/accelerate/blas


# According to CRAN -- this doesn't work!
# libRblas.vecLib.dylib does not exist (at least not in that location)
# https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html#Which-BLAS-is-used-and-how-can-it-be-changed_003f
#cd /Library/Frameworks/R.framework/Resources/lib
# for vecLib use
#ln -sf libRblas.vecLib.dylib libRblas.dylib
# for R reference BLAS use
#ln -sf libRblas.0.dylib libRblas.dylib

# This does work! Only links for the current version of R, but since this is set-up there is only one version installed
echo "Linking version of R just installed to the BLAS in the Apple Accelerate Framework"
# echo "The original link is backed-up to:"
# echo "  /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.dylib.bak"
# mv \
#   /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.dylib \
#   /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.dylib.bak
ln -sf \
  /System/Library/Frameworks/Accelerate.framework/Versions/Current/Frameworks/vecLib.framework/Versions/Current/libBLAS.dylib \
  /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.dylib
echo "To restore the default BLAS that comes with R use:"
echo "  $ ln -sf /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.0.dylib /Library/Frameworks/R.framework/Versions/Current/Resources/lib/libRblas.dylib"

# Not yet sure if need to do anything about the LAPACK

# use faster vecLib library -- this is the same as above, but with out the backup first, although not just for the current version
#cd /Library/Frameworks/R.framework/Resources/lib
#ln -sf  /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Versions/Current/libBLAS.dylib libRblas.dylib


#brew cask install microsoft-r-open


### Python (Homebrew version)
brew install python

### Text editors and IDEs
brew cask install visual-studio-code
brew cask install sublime-text
brew cask install rstudio
# brew cask install pycharm
brew cask install azure-data-studio

### Cloud command-line interfaces
brew install awscli
brew install azure-cli

### SQL
# brew install postgresql
# brew cask install postgres

### Blogging
brew install hugo

### Misc
brew cask install spotify

### Mac tools
brew cask install scroll-reverser

### Homebrew installations complete
brew cleanup
echo "... Homebrew software installations complete"


# Conda
echo "Installing Miniconda using their bash script (not Homebrew). You will be prompted multiple times."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -P ~/tmp
bash ~/tmp/Miniconda3-latest-MacOSX-x86_64.sh
rm ~/tmp/Miniconda3-latest-MacOSX-x86_64.sh

cat <<EOT >> ~/.condarc
changeps1: False
EOT

# Conda adds content to .bash_profile, but we want to manually call that when turning Conda on
mv ~/.bash_profile ~/bin/conda-on.sh
echo "echo \"Conda ready to use\"" >> ~/bin/conda-on.sh
source ~/bin/conda-on.sh

conda update conda
conda --version

# conda clean --all --yes ???
# AND ???
#conda install anaconda-clean ???
#anaconda-clean --yes ???

echo "Setting up Conda, including sandbox environment(s) for data science ..."

# CONDA installation stuff here
# JupyterLab

# Sandbox Python environment
# Python latest
# numpy, pandas, matplotlib
# scikit-learn
# tensorflow 2.0
# IPythonkernel

# Sandbox R
# IRkernel
# tidyverse
# caret

# Turn off conda
# !!! Need to get conda-off script !!! Maybe something like:
# wget <insert github url> -P ~/bin
source ~/bin/conda-off.sh


# Configure Git
echo "Configuring Git settings and aliases ..."
read -p "Enter global default Git email: " GIT_EMAIL

## Configure settings
git config --global user.name "Rob Jarvis"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "vim"

## Aliases
git config --global alias.unstage 'reset HEAD --' 
git config --global alias.unmod 'checkout --' 
git config --global alias.last 'log -1 HEAD' 
git config --global alias.pub 'push -u origin HEAD' 
git config --global alias.setemail 'config user.email jarvisrob@users.noreply.github.com' 
git config --global alias.cm 'commit -m' 
git config --global alias.co checkout 
git config --global alias.cob 'checkout -b' 
git config --global alias.aa 'add -A' 
git config --global alias.s status 
git config --global alias.ss 'status -s' 
git config --global alias.dm diff 
git config --global alias.ds 'diff --staged'

echo "... Done"


# macOS settings


# Close System Preferences to prevent conflicts with the settings changes
# The following is AppleScript called from the command line
# http://osxdaily.com/2016/08/19/run-applescript-command-line-macos-osascript/
osascript -e 'tell application "System Preferences" to quit'


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




# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true




# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0



# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0



# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"




# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false




# Dot files
# References:
#   - https://www.davidculley.com/dotfiles/
#   - https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980

# Configure shell aliases
# Edit ~/.aliases file

# Configure .profile
echo "Configuring .profile ..."
cat <<EOT > ~/.profile
PATH=/usr/local/opt/python/libexec/bin:$PATH:~/bin
EOT
echo "... Done"

# Configure .bashrc
echo "Configuring .bashrc ..."
cat <<EOT > ~/.bashrc
source .aliases
EOT
echo "... Done"

# Configure .bash_profile
echo "Configuring .bash_profile ..."
cat <<EOT > ~/.bash_profile
if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
EOT
echo "... Done"

# Z Shell
# cat <<EOT > ~/.zprofile
# [[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
# EOT

# cat <<EOT > ~/.zshrc
# source .aliases
# EOT

# Configure .vimrc (Vim)
echo "Configuring .vimrc"
cat <<EOT > ~/.vimrc
set number
syntax enable
EOT


# End
echo "Mac set-up completed"
