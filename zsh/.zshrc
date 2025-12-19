# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -Uz promptinit; promptinit

zstyle :prompt:pure:path color '#38bdf8'
zstyle :prompt:pure:git:branch color '#bae6fd'
zstyle :prompt:pure:git:arrow color '#34d399'
zstyle :prompt:pure:git:dirty color '#fdba74'

prompt pure

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment if Git every gets too slow in large repos
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

hh () {
  if [[ $# -gt 0 ]]; then
    history | grep "$1" | less +G
  else
    history | less +G
  fi
}

alias gcam="git commit -a -m"
alias gp="git push"
alias gsw="git switch"

alias lg="lazygit"

export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

# bun completions
[ -s "/Users/thomasyoung/.bun/_bun" ] && source "/Users/thomasyoung/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if [ -f ~/.github_token ]; then
  source ~/.github_token
fi

# android emulator
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-toolsexport PATH=$PATH:$HOME/.maestro/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
alias c="open $1 -a \"Cursor\""
alias v="open $1 -a \"Visual Studio Code\""


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"
