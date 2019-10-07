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
#------------------
# Shell Variables
#------------------

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
source /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add auto suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Add colorls tab completion
source $(dirname $(gem which colorls))/tab_complete.sh

# Add aliases
source ~/.aliases