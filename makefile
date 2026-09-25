.PHONY: init apply diff

# First time on a machine: writes ~/.config/chezmoi/chezmoi.toml pointing at
# this repo, then renders everything into ~.
init:
	chezmoi init --source $(CURDIR) --apply

apply:
	chezmoi apply

diff:
	chezmoi diff
