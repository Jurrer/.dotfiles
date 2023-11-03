#!/usr/bin/env bash

rm "$XDG_CONFIG_HOME/.tmuxp" &>/dev/null

if [ -n "$DOTFILES_CLOUD" ];
then
    # project relative configuration for neovim
    ln -sf "$DOTFILES_CLOUD/projects.nvimrc" "$VIMCONFIG"

    # if [ -d "$DOTFILES_CLOUD/openssh" ];
    # then
    #     if [ ! -d "$HOME/.ssh" ];
    #     then
    #         mkdir "$HOME/.ssh" > /dev/null
    #     fi

    #     rm "$HOME/.ssh/config" &>/dev/null

    #     cp "$DOTFILES_CLOUD/openssh/config" "$HOME/.ssh/config"
    #     chmod 700 "$HOME/.ssh/config"
    # fi
fi