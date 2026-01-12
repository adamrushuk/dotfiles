#!/bin/bash
echo -e "\n\e[38;5;135m╭───────────────────────────────────────────╮"
echo -e "│\e[38;5;220m    Dotfiles \e[38;5;135m  │"
echo -e "╰───────────────────────────────────────────╯"
echo -e "\e[38;5;33mAdam Rush     \e[38;5;40mv1.0.0     🚀  🎁  💥\n"
echo -e "\e[38;5;214m»»» 🙉 This script will remove & replace many of your personal dotfiles"
echo -e "\e[38;5;214m»»» 🙊 If you have anything in these files/folders, please back them up:"
echo -e "\e[38;5;214m»»» 🙈   \e[38;5;227m.bashenv .gitconfig .profile .bashrc ~/bin/ ~/tools/"
echo -e "\e[38;5;214m»»» 🐵 Only continue with this script when it is ok to overwrite these files...\n\e[0m"

PROMPT="1"
if [[ $1 == "noprompt" ]]; then
  PROMPT="0"
fi
if [[ -f /.dockerenv ]]; then
  PROMPT="0"
fi
if [[ $CODESPACES ]]; then
  PROMPT="0"
fi

if [[ "$PROMPT" == "1" ]]; then
  read -p "Are you sure? (y/n)" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      [[ "$0" = "$BASH_SOURCE" ]] && echo -e "\e[38;5;63m»»» 😇 OK, exiting without making changes, bye!\n\e[0m" && exit 1 || return 1
  fi
fi

#
# Install oh-my-posh
# debug cmd: oh-my-posh debug
echo -e "\n\e[38;5;45m»»» Installing oh-my-posh (custom prompt)... \e[0m"
mkdir -p ~/.local/bin
sudo apt-get install -y unzip
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin/
chmod +x ~/.local/bin/oh-my-posh

#
# Create symlinks for all dotfiles and bin directory
#
dotfiles_dir="$HOME/dotfiles"

for f in bin .aliases.rc .banner.rc .bashrc .gitconfig .go-my-posh.json .profile; do
  target="$HOME/$f"
  source="$dotfiles_dir/$f"

  echo "Processing: $f"

  # Ensure source file exists
  if [ ! -e "$source" ]; then
    echo -e "❌ Source not found: $source"
    continue
  fi

  # Remove existing file/symlink if present
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -f "$target" && echo "  🔄 Removed existing $target" || { echo "❌ Failed to remove $target"; continue; }
  fi

  # Create symlink
  ln -s "$source" "$target" && echo "  ✅ Symlink created: $target → $source" || echo "❌ Failed to create symlink: $target"

done

# env
if [ -L "$HOME/.bashenv" ] && [ "$(readlink "$HOME/.bashenv")" = "$HOME/dotfiles/.env.rc" ]; then
    echo "  ✅ Symlink already correct: $HOME/.bashenv → $HOME/dotfiles/.env.rc"
else
    rm "$HOME/.bashenv"
    ln -s "$HOME/dotfiles/.env.rc" "$HOME/.bashenv" && echo "  ✅ Symlink created: $HOME/.bashenv → $HOME/dotfiles/.env.rc" || echo "❌ Failed to create symlink: $HOME/.bashenv"
fi

# powershell
mkdir -p "$HOME/.config/powershell/"
if [ -L "$HOME/.config/powershell/profile.ps1" ] && [ "$(readlink "$HOME/.config/powershell/profile.ps1")" = "$HOME/dotfiles/profile.ps1" ]; then
    echo "  ✅ Symlink already correct: $HOME/.config/powershell/profile.ps1 → $HOME/dotfiles/profile.ps1"
else
    ln -s "$HOME/dotfiles/profile.ps1" "$HOME/.config/powershell/profile.ps1" && echo "  ✅ Symlink created: $HOME/.config/powershell/profile.ps1 → $HOME/dotfiles/profile.ps1" || echo "❌ Failed to create symlink: $HOME/.config/powershell/profile.ps1"
fi

# Git user configuration
echo -e "\n\e[38;5;45m»»» Configuring Git user info... \e[0m"
echo "Enter your Git email:"
read -r email
git config --global user.email "$email"
echo "Enter your Git name:"
read -r name
git config --global user.name "$name"

#
# Clone my setup scripts
#
echo -e "\n\e[38;5;45m»»» Cloning tools repo to $HOME/tools \e[0m"
rm -rf "$HOME/tools"
git clone -q https://github.com/adamrushuk/tools-install.git "$HOME/tools"
