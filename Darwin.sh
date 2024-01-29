#!/usr/bin/env bash

setup_colors() {
  # Only use colors if connected to a terminal
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    CYAN=$(printf '\033[36m')
    BLUE=$(printf '\033[34m')
    LBLUE=$(printf '\033[94m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}
setup_colors

dir=$(pwd)

echo "${GREEN}installing delevoper tools...${RESET}"
xcode-select --install

if ! command -v brew &> /dev/null; then
  echo "${GREEN}installing homebrew${RESET}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else 
  echo "${LBLUE}homebrew already installed${RESET}"
fi

brew update
brew install git iterm2 neovim ngrok ripgrep tree-sitter lua luajit httpie jq bat tldr librsvg fx exa duff diff-so-fancy hexyl hexedit gcal fnm tmux postgresql@14 luarocks gnu-sed pnpm fd fzf tidy-html5 cargo-nextest tailspin
brew tap oven-sh/bun 
brew install bun
brew upgrade

fnm install --lts
fnm use --lts
npm i -g livedown

echo "${GREEN}tmux plugin manager and themes${RESET}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else 
  echo "${LBLUE}tpm already installed${RESET}"
fi

if [ ! -d ~/.tmux-themepack ]; then
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
else
  echo "${LBLUE}tmux-themepack already installed${RESET}"
fi

echo "${GREEN}installing rust${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "${BLUE}adding rustfmt component${RESET}"
rustup component add rustfmt
rustup component add clippy
cargo install sleek

cd ~
mkdir repos

if [ ! -d ~/repos/vscode-node-debug2 ]; then
  echo "${GREEN}installing node-debug2${RESET}"
  cd ~/repos
  git clone https://github.com/microsoft/vscode-node-debug2.git
  cd vscode-node-debug2
  npm ci
  NODE_OPTIONS=--no-experimental-fetch npm run build
fi

if [ ! -d ~/.oh-my-zsh ]; then
  echo "${GREEN}installing oh-my-zsh${RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "${GREEN}installing oh-my-zsh plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode

echo "${CYAN}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cd $dir

olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="tmux.conf tmux.conf.local zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
config="nvim"

mkdir -p $olddir
cd $HOME

echo "${BLUE}symlink for ~/bin${RESET}"
ln -s $dir/bin bin

echo "${BLUE}updating dotfiles${RESET}"
for file in $files; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv ~/.$file $olddir/.$file.bak
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file .$file
done

# symlinks for .config
mkdir -p ~/oldconfig
mkdir -p ~/.config
cd ~/.config

for file in $config; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv $file $oldconfig
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file $file
done

echo "${YELLOW}changing shell...${RESET}"
zsh=$(command -v zsh)
if ! chsh -s "$zsh"; then
  fmt_error "chsh command unsuccessful. Change your default shell manually."
else
  export SHELL="$zsh"
  echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
fi

cd $HOME
echo "${GREEN}We are done! 🥳${RESET}"
exec zsh -l
