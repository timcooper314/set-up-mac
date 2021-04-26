#------------------
# Zsh Config
#------------------

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=5000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e

# Auto-completion
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

#autoload -Uz bashcompinit
#bashcompinit
#source /usr/local/etc/profile.d/bash_completion.sh
#------------------
# Shell Variables
#------------------
# Add pyenv to PATH
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Add and switch between JAVA versions
export JAVA_HOME=$(/usr/libexec/java_home -v15)
#export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
#export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_14_HOME=$(/usr/libexec/java_home -v14)

#alias java8='export JAVA_HOME=$JAVA_8_HOME'
#alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java14='export JAVA_HOME=$JAVA_14_HOME'
# Set VS Code as default code editor
export EDITOR=visual-studio-code

#------------------
# Zsh hooks
#------------------

# Enable the addition of zsh hook functions
autoload -U add-zsh-hook

#------------------
# Miscellaneous
#------------------

# Allow the use of the z plugin to easily navigate directories
source /usr/local/etc/profile.d/z.sh

# Set pure as a prompt
autoload -U promptinit
promptinit
prompt pure

# Add colors to terminal commands (green command means that the command is valid)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add auto suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Add colorls tab completion
source $(dirname $(gem which colorls))/tab_complete.sh

# Add aliases
source ~/.aliases
