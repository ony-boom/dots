# dots

    make init    # first time: point chezmoi at this repo and apply
    make diff    # preview
    make apply   # render into ~

## Layout

    home/                       chezmoi source state (.chezmoiroot), mirrors ~
      .chezmoidata/packages.yaml  dnf / copr / flatpak package lists
      .chezmoiexternal.toml       zsh plugins fetched on apply
      .chezmoiscripts/            run_onchange_ setup scripts, run in name order
      dot_config/                 -> ~/.config
      dot_local/                  -> ~/.local (bin, fonts)
