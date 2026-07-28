# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

typeset -U path fpath
ORBSTACK_ZSH_COMPLETIONS="/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh"
if [[ -d "$ORBSTACK_ZSH_COMPLETIONS" && "${fpath[(Ie)$ORBSTACK_ZSH_COMPLETIONS]}" -eq 0 ]]; then
  fpath+=("$ORBSTACK_ZSH_COMPLETIONS")
fi
unset ORBSTACK_ZSH_COMPLETIONS

fpath+=(/opt/homebrew/share/zsh/site-functions)
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

source "$ZSH/oh-my-zsh.sh"

hh () {
  if [[ $# -gt 0 ]]; then
    history | grep "$1" | less +G
  else
    history | less +G
  fi
}

kexf () {
  if [[ $# -lt 1 ]]; then
    echo "Usage: kexf <namespace>"
    return 1
  fi

  local namespace="$1"
  local pod_name

  pod_name=$(kubectl get pods -n "$namespace" -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.name}{"\t"}{range .status.conditions[?(@.type=="Ready")]}{.status}{end}{"\n"}{end}' | grep $'\tTrue$' | head -n 1 | cut -f1)

  if [[ -z "$pod_name" ]]; then
    echo "No pods found in namespace $namespace"
    return 1
  fi

  echo "Connecting to pod: $pod_name"

  kubectl exec -it -n "$namespace" "$pod_name" -- bash 2>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "bash not available, trying sh..."
    kubectl exec -it -n "$namespace" "$pod_name" -- sh
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

export XDG_CONFIG_HOME="$HOME/.config"
alias c="open $1 -a \"Cursor\""
alias v="open $1 -a \"Visual Studio Code\""


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(mise activate zsh)"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/thomas/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

#compdef just

autoload -U is-at-least

_just() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    local common=(
'(--no-aliases)--alias-style=[Set list command alias display style]: :(left right separate)' \
'--ceiling=[Do not ascend above <CEILING> directory when searching for a justfile.]: :_files' \
'--chooser=[Override binary invoked by \`--choose\`]: :_default' \
'--color=[Print colorful output]: :(always auto never)' \
'--command-color=[Echo recipe lines in <COMMAND-COLOR>]: :(black blue cyan green purple red yellow)' \
'--cygpath=[Use binary at <CYGPATH> to convert between unix and Windows paths.]: :_files' \
'(-E --dotenv-path)--dotenv-filename=[Search for environment file named <DOTENV-FILENAME> instead of \`.env\`]: :_default' \
'-E+[Load <DOTENV-PATH> as environment file instead of searching for one]: :_files' \
'--dotenv-path=[Load <DOTENV-PATH> as environment file instead of searching for one]: :_files' \
'--dump-format=[Dump justfile as <FORMAT>]:FORMAT:(json just)' \
'-f+[Use <JUSTFILE> as justfile]: :_files' \
'--justfile=[Use <JUSTFILE> as justfile]: :_files' \
'--list-heading=[Print <TEXT> before list]:TEXT:_default' \
'--list-prefix=[Print <TEXT> before each list item]:TEXT:_default' \
'*--set=[Override <VARIABLE> with <VALUE>]: :(_just_variables)' \
'--shell=[Invoke <SHELL> to run recipes]: :_default' \
'*--shell-arg=[Invoke shell with <SHELL-ARG> as an argument]: :_default' \
'--tempdir=[Save temporary files to <TEMPDIR>.]: :_files' \
'--timestamp-format=[Timestamp format string]: :_default' \
'-d+[Use <WORKING-DIRECTORY> as working directory. --justfile must also be set]: :_files' \
'--working-directory=[Use <WORKING-DIRECTORY> as working directory. --justfile must also be set]: :_files' \
'*-c+[Run an arbitrary command with the working directory, \`.env\`, overrides, and exports set]: :_default' \
'*--command=[Run an arbitrary command with the working directory, \`.env\`, overrides, and exports set]: :_default' \
'--completions=[Print shell completion script for <SHELL>]:SHELL:(bash elvish fish nushell powershell zsh)' \
'()-l+[List available recipes in <MODULE> or root if omitted]' \
'()--list=[List available recipes in <MODULE> or root if omitted]' \
'--request=[Execute <REQUEST>. For internal testing purposes only. May be changed or removed at any time.]: :_default' \
'-s+[Show recipe at <PATH>]: :(_just_commands)' \
'--show=[Show recipe at <PATH>]: :(_just_commands)' \
'()--usage=[Print recipe usage information]:PATH:_default' \
'--check[Run \`--fmt\` in '\''check'\'' mode. Exits with 0 if justfile is formatted correctly. Exits with 1 and prints a diff if formatting is required.]' \
'--clear-shell-args[Clear shell arguments]' \
'(-q --quiet)-n[Print what just would do without doing it]' \
'(-q --quiet)--dry-run[Print what just would do without doing it]' \
'--explain[Print recipe doc comment before running it]' \
'(-f --justfile -d --working-directory)-g[Use global justfile]' \
'(-f --justfile -d --working-directory)--global-justfile[Use global justfile]' \
'--highlight[Highlight echoed recipe lines in bold]' \
'--list-submodules[List recipes in submodules]' \
'--no-aliases[Don'\''t show aliases in list]' \
'--no-deps[Don'\''t run recipe dependencies]' \
'--no-dotenv[Don'\''t load \`.env\` file]' \
'--no-highlight[Don'\''t highlight echoed recipe lines in bold]' \
'--one[Forbid multiple recipes from being invoked on the command line]' \
'(-n --dry-run)-q[Suppress all output]' \
'(-n --dry-run)--quiet[Suppress all output]' \
'--allow-missing[Ignore missing recipe and module errors]' \
'--shell-command[Invoke <COMMAND> with the shell used to run recipe lines and backticks]' \
'--timestamp[Print recipe command timestamps]' \
'-u[Return list and summary entries in source order]' \
'--unsorted[Return list and summary entries in source order]' \
'--unstable[Enable unstable features]' \
'*-v[Use verbose output]' \
'*--verbose[Use verbose output]' \
'--yes[Automatically confirm all recipes.]' \
'--changelog[Print changelog]' \
'--choose[Select one or more recipes to run using a binary chooser. If \`--chooser\` is not passed the chooser defaults to the value of \$JUST_CHOOSER, falling back to \`fzf\`]' \
'--dump[Print justfile]' \
'-e[Edit justfile with editor given by \$VISUAL or \$EDITOR, falling back to \`vim\`]' \
'--edit[Edit justfile with editor given by \$VISUAL or \$EDITOR, falling back to \`vim\`]' \
'--evaluate[Evaluate and print all variables. If a variable name is given as an argument, only print that variable'\''s value.]' \
'--fmt[Format and overwrite justfile]' \
'--groups[List recipe groups]' \
'--init[Initialize new justfile in project root]' \
'--man[Print man page]' \
'--summary[List names of available recipes]' \
'--variables[List names of variables]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
)

    _arguments "${_arguments_options[@]}" $common \
        '1: :_just_commands' \
        '*: :->args' \
        && ret=0

    case $state in
        args)
            curcontext="${curcontext%:*}-${words[2]}:"

            local lastarg=${words[${#words}]}
            local recipe

            local cmds; cmds=(
                ${(s: :)$(_call_program commands just --summary)}
            )

            # Find first recipe name
            for ((i = 2; i < $#words; i++ )) do
                if [[ ${cmds[(I)${words[i]}]} -gt 0 ]]; then
                    recipe=${words[i]}
                    break
                fi
            done

            if [[ $lastarg = */* ]]; then
                # Arguments contain slash would be recognised as a file
                _arguments -s -S $common '*:: :_files'
            elif [[ $lastarg = *=* ]]; then
                # Arguments contain equal would be recognised as a variable
                _message "value"
            elif [[ $recipe ]]; then
                # Show usage message
                _message "`just --show $recipe`"
                # Or complete with other commands
                #_arguments -s -S $common '*:: :_just_commands'
            else
                _arguments -s -S $common '*:: :_just_commands'
            fi
        ;;
    esac

    return ret

}

(( $+functions[_just_commands] )) ||
_just_commands() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local variables; variables=(
        ${(s: :)$(_call_program commands just --variables)}
    )
    local commands; commands=(
        ${${${(M)"${(f)$(_call_program commands just --list)}":#    *}/ ##/}/ ##/:Args: }
    )

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            *) _message 'value' && ret=0 ;;
        esac
    else
        _describe -t variables 'variables' variables -qS "=" && ret=0
        _describe -t commands 'just commands' commands "$@"
    fi

}

if [ "$funcstack[1]" = "_just" ]; then
    (( $+functions[_just_variables] )) ||
_just_variables() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local variables; variables=(
        ${(s: :)$(_call_program commands just --variables)}
    )

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            *) _message 'value' && ret=0 ;;
        esac
    else
        _describe -t variables 'variables' variables && ret=0
    fi

    return ret
}

_just "$@"
else
    compdef _just just
fi

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
