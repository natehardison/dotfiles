# dotfiles

Personal dotfiles for macOS and Linux.

## Install

**macOS:**

    xcode-select --install
    git clone git@github.com:natehardison/dotfiles.git ~/src/dotfiles
    cd ~/src/dotfiles && make

**Linux / Raspberry Pi / EC2:**

    git clone git@github.com:natehardison/dotfiles.git ~/src/dotfiles
    cd ~/src/dotfiles && make

**Devcontainer:**

    make minimal

## Profiles

| Target | What it does |
|--------|-------------|
| `make` | Auto-detects: `full` on macOS, `minimal` on Linux |
| `make minimal` | CLI tools + all configs |
| `make full` | minimal + nvim, ghostty, wireshark (+ casks & screenshots on macOS) |

Individual targets (`make vim`, `make ssh`, etc.) also work standalone.

## Package management

CLI tools are installed via Homebrew on macOS (`brew/Brewfile`) and
[ubi](https://github.com/houseabsolute/ubi) on Linux (`ubi/tools`).
GUI apps are in `brew/Caskfile` and only installed by `make full`.

## Shell

Zsh with [antidote](https://github.com/mattmc3/antidote) for plugin
management and [starship](https://starship.rs) for the prompt.
Machine-specific config goes in `~/.zsh.d/` (sourced automatically).

## Vim / Neovim

Vim is a lightweight base config (tpope essentials, fzf, fugitive).
Neovim sources it and adds the IDE layer: treesitter, coc.nvim,
gutentags, tagbar, CHADtree. Plugins managed by
[vim-plug](https://github.com/junegunn/vim-plug).

## SSH

Uses `Include config.d/*` for modular configs. The 1Password SSH agent
is conditionally enabled via `Match exec` (works on both macOS and Linux).

On headless Linux boxes (no 1Password), `make ssh-agent` installs a
persistent user-scoped `ssh-agent` as a systemd user service, so a
single agent is shared across every login instead of one spawned per
shell. It's standalone (not in `minimal`/`full`) and a no-op without a
systemd user instance. Run `loginctl enable-linger $USER` once so the
agent survives with no active login. The shell adopts its socket only
when `SSH_AUTH_SOCK` is unset, leaving forwarded agents alone.
