set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR 'zed --wait'
set -gx VISUAL $EDITOR
set -g fish_greeting

fish_add_path --prepend \
    $HOME/.opencode/bin \
    $HOME/.local/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin

set -gx LIBRARY_PATH $LIBRARY_PATH /opt/homebrew/lib

if test -f $HOME/.orbstack/shell/init2.fish
    source $HOME/.orbstack/shell/init2.fish
end

if test -d /Applications/OrbStack.app/Contents/Resources/completions/fish
    set -p fish_complete_path /Applications/OrbStack.app/Contents/Resources/completions/fish
end

if status is-interactive
    mise activate fish | source

    abbr --add gcam git commit -a -m
    abbr --add gp git push
    abbr --add gsw git switch
    abbr --add lg lazygit
    abbr --add oc opencode
end
