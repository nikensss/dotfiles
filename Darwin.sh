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

echo "${GREEN}installing delevoper tools...${RESET}"
xcode-select --install

echo "${GREEN}installing homebrew${RESET}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew update
brew install git iterm2 neovim ngrok ripgrep tree-sitter luajit pyenv asdf httpie jq bat tldr librsvg fx exa duff diff-so-fancy hexyl hexedit gcal lua-language-server fnm tmux helix
brew upgrade

fnm install --lts
fnm use --lts
npm i -g diagnostic-languageserver eslint_d live-server livedown prettier prettier-plugin-java prettier-plugin-prisma pyright typescript typescript-language-server yarn tree-sitter-yaml tree-sitter

echo "${GREEN}installing python"
pyenv install $(pyenv install --list | grep --extended-regexp "^\s*[0-9][0-9.]*[0-9]\s*$" | tail -1)
pyenv global $(pyenv install --list | grep --extended-regexp "^\s*[0-9][0-9.]*[0-9]\s*$" | tail -1)
python3 -m pip install --user --upgrade pynvim


echo "${GREEN}tmux plugin manager and themes${RESET}"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

echo "${GREEN}installing rust${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "${BLUE}adding rustfmt component${RESET}"
rustup component add rustfmt
rustup component add clippy
cd ~
mkdir repos
cd repos
mkdir rust
cd rust
echo "${BLUE}cloning rust-analyzer${RESET}"
git clone https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
echo "${BLUE}installing rust language server${RESET}"
cargo xtask install --server
cargo install stylua

echo "${GREEN}installing node-debug2${RESET}"
cd ~/repos
mkdir javascript
cd javascript
git clone https://github.com/microsoft/vscode-node-debug2.git
cd vscode-node-debug2
npm ci
NODE_OPTIONS=--no-experimental-fetch npm run build

echo "${GREEN}installing java language server${RESET}"
cd ~/repos
mkdir java
cd java
asdf plugin-add java
asdf install java openjdk-17.0.2
asdf global java openjdk-17.0.2

echo "${GREEN}installing oh-my-zsh${RESET}"
sh -c "$(curl https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended

echo "${GREEN}installing vim-plug${RESET}"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "${GREEN}installing plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "${CYAN}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

dir=$(pwd)
olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="vimrc tmux.conf zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
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
  mv .$file $oldconfig
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
