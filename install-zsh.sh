#!/bin/sh

#
# Simple script to install zsh and try to change default shell to it
#
echo -e "\e[34m»»» 🚀 \e[32mInstalling \e[33m'zsh'\e[32m ... \e[39m"
sudo apt update
sudo apt install -y zsh

echo -e "\e[34m»»» 🚀 \e[32mChanging default shell to \e[33m'zsh'\e[32m ... \e[39m"
chsh -s /usr/bin/zsh "$USER"
