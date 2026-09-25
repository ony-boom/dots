# dots

Dotfiles managed with [chezmoi](https://chezmoi.io). This repo is the chezmoi
source dir (`dot_config/` → `~/.config`, `private_dot_ssh/` → `~/.ssh`, ...).
Files are copies, not symlinks: edit here, then `make apply`.

Host differences live in `*.tmpl` files keyed on `{{ .chezmoi.hostname }}`.

    make init    # first time: point chezmoi at this repo and apply
    make diff    # preview
    make apply   # render into ~
