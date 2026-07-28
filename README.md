# Dotfiles

## `bootstrap.sh`

Bootstrap an Apple Silicon Mac with one command:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thomas-young1/dotfiles/main/bootstrap.sh)"
```

This:

1. Enables Touch ID for `sudo`
2. Installs Homebrew and mise
3. Clones this repository to `~/.dotfiles`
4. Applies the mise `bootstrap` configuration
