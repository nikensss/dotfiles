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

echo "${BLUE}installing nvm${RESET}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
npm i -g yarn typescript typescript-language-server diagnostic-languageserver eslint_d prettier pyright livedown

echo "${GREEN}installing homebrew${RESET}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew update
brew install git iterm2 neovim ngrok ripgrep tree-sitter luajit pyenv asdf
brew upgrade

echo "${GREEN}installing python"
pyenv install $(pyenv install --list | grep --extended-regexp "^\s*[0-9][0-9.]*[0-9]\s*$" | tail -1)
pyenv global $(pyenv install --list | grep --extended-regexp "^\s*[0-9][0-9.]*[0-9]\s*$" | tail -1)
python3 -m pip install --user --upgrade pynvim


echo "${GREEN}installing rust${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "${BLUE}adding rustfmt component${RESET}"
rustup component add rustfmt
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

echo "${GREEN}installing oh-my-zsh${RESET}"
sh -c "$(curl https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended

echo "${GREEN}installing vim-plug${RESET}"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "${GREEN}installing plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "${CYAN}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

dir=$HOME/dotfiles
olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="vimrc zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
config="nvim"

mkdir -p $olddir
cd $HOME

echo "${BLUE}updating dotfiles${RESET}"
for file in $files; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv ~/.$file $olddir
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
