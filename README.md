# My dotfiles repo

## Setup

First clone this repo in home dir

```bash
git clone https://github.com/KLTPL/dotfiles
```

### Zsh

1. Download zsh

```bash
sudo apt update
sudo apt install zsh
```

2. Set Zsh as the default shell

```bash
chsh -s $(which zsh)
```

3. Download [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/)

4. Download all plugins using the zsh-install.sh script

```bash
~/dotfiles/zsh-install.sh
```

5. Create symlink for zsh

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
```

6. Create symlink for powerlevel10k if installed via zsh-install.sh

```bash
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
```

### LazyVim

```bash
mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config/nvim
```

### Git

```bash
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
```
