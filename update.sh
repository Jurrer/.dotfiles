#!/usr/bin/env bash

source "$DOTFILES/colors.sh"
source "$DOTFILES/install_functions.sh"
source "$DOTFILES/install_config"

#---------------------------------------

# backup zsh history file
mkdir -p "$DOTFILES_CLOUD/zsh"
cp "$ZDOTDIR/zsh_history" "$DOTFILES_CLOUD/zsh/zsh_history-$(date +%F)"

#---------------------------------------

dot_mes_update "Neovim plugins"
nvim --noplugin +PlugUpdate +qa

#---------------------------------------

# sudo pacman -Syu
