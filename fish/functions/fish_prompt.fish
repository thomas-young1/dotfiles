function fish_prompt
    set -l last_status $status

    set -g __fish_git_prompt_showcolorhints true
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_show_informative_status true
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_char_stateseparator ' '
    set -g __fish_git_prompt_char_dirtystate '~'
    set -g __fish_git_prompt_char_stagedstate '+'
    set -g __fish_git_prompt_char_invalidstate '!'
    set -g __fish_git_prompt_char_untrackedfiles '?'
    set -g __fish_git_prompt_char_cleanstate ''
    set -g __fish_git_prompt_char_upstream_prefix ' '
    set -g __fish_git_prompt_char_upstream_ahead '↑'
    set -g __fish_git_prompt_char_upstream_behind '↓'
    set -g __fish_git_prompt_color_branch bae6fd
    set -g __fish_git_prompt_color_dirtystate fdba74
    set -g __fish_git_prompt_color_stagedstate fdba74
    set -g __fish_git_prompt_color_untrackedfiles fdba74
    set -g __fish_git_prompt_color_upstream 34d399

    set_color 38bdf8
    printf '%s' (prompt_pwd --full-length-dirs 2)
    set_color normal
    fish_git_prompt '  %s'
    printf '\n'

    if test $last_status -eq 0
        set_color 34d399
    else
        set_color brred
    end
    printf '❯ '
    set_color normal
end
