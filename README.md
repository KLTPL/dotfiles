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

2. Download [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/)

3. Download [Zsh autosuggestions plugin](https://github.com/zsh-users/zsh-autosuggestions/)

4. Create symlink

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
```

### LazyVim

```bash
ln -s ~/dotfiles/nvim ~/.config/nvim
```

### Git

```bash
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
```
