# Dotfiles

## `bootstrap.sh`

Bootstrap an Apple Silicon Mac with one command:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thomas-young1/dotfiles/main/bootstrap.sh)"
```

This:

1. Installs Homebrew and mise
2. Clones this repository to `~/.dotfiles`
3. Applies the mise `bootstrap` configuration
