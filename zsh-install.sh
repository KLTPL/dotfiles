#!/bin/bash

echo "Starting ZSH config..."

# Custom plugins dir
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

THEMES=(
  "https://github.com/romkatv/powerlevel10k.git"
)

echo "Download plugins..."

for repo in "${PLUGINS[@]}"; do
  plugin_name=$(basename "$repo" .git)
  target_dir="$ZSH_CUSTOM/plugins/$plugin_name"

  if [ ! -d "$target_dir" ]; then
    echo "⬇️ Cloning plugin: $plugin_name..."
    git clone "$repo" "$target_dir"
  else
    echo "✅ Plugin $plugin_name already exists."
  fi
done

echo "Download themes..."

for repo in "${THEMES[@]}"; do
  theme_name=$(basename "$repo" .git)
  target_dir="$ZSH_CUSTOM/themes/$theme_name"

  if [ ! -d "$target_dir" ]; then
    echo "⬇️ Cloning plugin: $theme_name..."
    git clone --depth=1 "$repo" "$target_dir"
  else
    echo "✅ Theme $theme_name already exists."
  fi
done

echo "🎉 Done!"
