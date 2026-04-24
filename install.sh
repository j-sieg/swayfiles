#!/usr/bin/env bash
set -e

CONFIGS=(sway foot waybar rofi alacritty)

echo "📦 Installing core tools..."
sudo rpm-ostree install alacritty btop fastfetch

if fc-list | grep -qi "RobotoMono Nerd Font"; then
  echo "🔤 RobotoMono Nerd Font already installed, skipping..."
else
  echo "🔤 Installing Nerd Font (RobotoMono)..."

  mkdir -p ~/.local/share/fonts

  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR"

  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/RobotoMono.zip
  unzip -o RobotoMono.zip -d ~/.local/share/fonts/

  fc-cache -fv

  cd ~
  rm -rf "$TMP_DIR"
fi

echo "📁 Preparing ~/.config..."
mkdir -p ~/.config

for cfg in "${CONFIGS[@]}"; do
  echo "🔗 Linking $cfg..."
  rm -rf ~/.config/"$cfg"
  ln -s ~/swayfiles/"$cfg" ~/.config/"$cfg"
done

echo "✅ Setup complete!"
echo "🔁 Reboot required for rpm-ostree package changes."
