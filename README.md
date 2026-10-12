# My dotfiles repo

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage configuration files via automated symlinking.

## Repository Structure

To work with Stow, the repository is organized into "packages" (folders) that mirror the directory structure of your home folder.

## Claude Code

I write about my Claude Code skills and design workflow in the `claude/.claude/README.md` file.

## LazyVim

I write about my LazyVim config in the `nvim/.config/nvim/README.md` file.

## Setup

First, clone this repo into your home directory:

```bash
git clone https://github.com/KLTPL/dotfiles ~/dotfiles
```

#### 1. Install Dependencies

Install Zsh and GNU Stow:

```bash
sudo apt update
sudo apt install zsh stow
```

#### 2. Configure Zsh Environment

1. Download [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/).
2. Download all plugins using the provided installation script:

   ```bash
   ~/dotfiles/zsh-install.sh
   ```

3. Set Zsh as the default shell:

   ```bash
   chsh -s $(which zsh)
   ```

4. If Powerlevel10k was installed via the `zsh-install.sh` script, go to the [powerlevel10k github page](https://github.com/romkatv/powerlevel10k) to download the necessary additional fonts.

#### 3. Apply Configurations with Stow

Instead of manually linking each file, use Stow from within the `dotfiles` directory to generate all symlinks automatically. Ensure you have moved your old configuration files (or deleted default ones) to avoid Stow conflict errors.

```bash
cd ~/dotfiles

# Stow all your packages
stow zsh git nvim kitty claude
```

The `nvim` package also links an `nvim-ide` script into `~/.local/bin/` and a **Neovim IDE** launcher (`nvim/.local/share/applications/nvim-ide.desktop`) into `~/.local/share/applications/`. The script opens nvim maximized in its own terminal window class, so Alt+Tab shows it as a separate app instead of another terminal. It is the only place that names the terminal (currently `kitty`), so change the terminal there.

The `nv` zsh function calls the same script, hides the terminal you ran it from, and brings it back when nvim exits. It requires an X11 session and the `xdotool` and `wmctrl` packages:

```bash
sudo apt install xdotool wmctrl
```

#### 4. Root User Configuration

To use your Zsh and Neovim configurations as the root user, use Stow's `-t` (target) and `-d` (directory) flags to link the files into the `/root` home directory, while maintaining the manual link for the `.oh-my-zsh` directory:

```bash
sudo -i

# Link the Oh My Zsh framework
ln -sf /home/kltpl/.oh-my-zsh /root/.oh-my-zsh

# Use Stow to link the dotfiles directly into /root
stow -d /home/kltpl/dotfiles -t /root zsh nvim
```
