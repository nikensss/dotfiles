#!/bin/bash

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

echo "${BLUE}installing zsh, curl, wget, git, and more...${RESET}"
apt-get update
apt-get install -y curl wget zsh git ripgrep tree-sitter lua fd luajit httpie jq bat tldr librsvg fx duff diff-so-fancy hexedit fnm tmux luarocks gnu-sed fd fzf tidy-html5 cargo-nextest tailspin delve gleam erlang rebar3 cmake exiftool asdf llvm boost pyenv pyenv-virtualenv

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

# rust and cargo
echo "${GREEN}installing rust${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "${BLUE}installing cargo${RESET}"
curl https://sh.rustup.rs -sSf | sh
rustup component add rustfmt
rustup component add clippy
cargo install sleek silicon

# install fnm
echo "${BLUE}installing fnm${RESET}"
cargo install fnm
fnm install --lts
fnm use --lts
npm i -g neovim

mkdir repos && cd repos

echo "${BLUE}installing and building LuaJIT${RESET}"
mkdir lua && cd lua
git clone https://github.com/LuaJIT/LuaJIT.git
cd LuaJIT
make
make install

if [ ! -d ~/repos/vscode-js-debug ]; then
  echo "${GREEN}installing vscode-js-debug${RESET}"
  cd ~/repos
  git clone git@github.com:microsoft/vscode-js-debug.git
  cd vscode-js-debug
  npm install --legacy-peer-deps
  npx gulp vsDebugServerBundle
  mv dist out
fi

echo "${BLUE}installing oh-my-zsh${RESET}"
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended

echo "${BLUE}installing plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "${BLUE}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

dir=$HOME/dotfiles
olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="tmux.conf zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
config="nvim"

echo "${BLUE}symlink for ~/bin${RESET}"
ln -s $dir/bin ~/bin

# create backup folder
mkdir -p $olddir
cd $dir

echo "${BLUE}updating dotfiles${RESET}"
for file in $files; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv ~/.$file $olddir
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file ~/.$file
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
