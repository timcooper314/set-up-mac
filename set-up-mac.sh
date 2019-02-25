#!/bin/bash

echo "Shell script to set-up a new Mac"


# Configure .bashrc
echo "Configuring .bashrc ..."


echo "... Done"


# SSH keys
echo "Generating SSH keys"
echo "You will be prompted for email, file location (enter for default) and passphrase"
read -p "Enter your email: " USER_EMAIL
ssh-keygen -t rsa -b 4096 -C "$USER_EMAIL"
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


# Homebrew

## Install Homebrew itself
echo "Installing Homebrew ..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
echo "Done ..."


## Install software
echo "Installing software using Homebrew ..."

### Terminal tools
brew install wget

### Dev tools
brew install git


### Productivity
brew cask install alfred
brew cask install google-chrome
brew cask install firefox



### Text editors
brew cask install visual-studio-code


### R


### Conda



echo "... Homebrew software installations complete"




# Git
echo "Configuring Git settings and aliases ..."


## Configure settings
git config --global user.name "Rob Jarvis"
git config --global user.email rob.jarvis@readify.net
# git config --global core.editor
# Setting up editor goes here ...

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


# Vim
# vim configuration goes here, unless it goes into bashrc?


# Conda
echo "Setting up Conda, including 'sandbox' environment for data science ..."


echo "... Conda set-up complete"


# End
echo "Mac set-up completed"

