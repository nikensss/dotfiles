#!/usr/bin/env bash

# Check if running on Ubuntu
if ! grep -qi ubuntu /etc/os-release 2>/dev/null; then
  echo "Error: This script is designed for Ubuntu only."
  echo "Detected OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME || echo 'Unknown')"
  exit 1
fi

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

echo "${GREEN}Running Ubuntu setup script${RESET}"
echo "${LBLUE}Ubuntu version: $(lsb_release -d | cut -f2)${RESET}"

dir=$(pwd)

# Add necessary PPAs and repositories
echo "${BLUE}Adding repositories...${RESET}"
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

echo "${BLUE}Updating package lists...${RESET}"
sudo apt-get update

echo "${BLUE}Installing packages via apt...${RESET}"
sudo apt-get install -y \
  curl wget zsh git ripgrep lua5.4 liblua5.4-dev luajit libluajit-5.1-dev \
  httpie jq bat tldr librsvg2-bin duff diff-so-fancy hexedit tmux luarocks \
  sed fd-find fzf tidy cmake exiftool erlang rebar3 llvm libboost-all-dev \
  build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev unzip gcal postgresql-16 ninja-build gettext pkg-config

# Create symlinks for fd (fd-find on Ubuntu)
sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true

# Install pyenv
echo "${BLUE}Installing pyenv...${RESET}"
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
else
  echo "${LBLUE}pyenv already installed${RESET}"
fi

# rust and cargo
echo "${GREEN}Installing Rust and Cargo...${RESET}"
if ! command -v rustc &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "${LBLUE}Rust already installed${RESET}"
fi

rustup component add rustfmt clippy

# Install Rust-based tools
echo "${BLUE}Installing Rust packages...${RESET}"
cargo install \
  sleek \
  silicon \
  fnm \
  hexyl \
  cargo-nextest \
  tailspin \
  nixpacks

# Install Go (for delve and other tools)
echo "${BLUE}Installing Go...${RESET}"
if ! command -v go &> /dev/null; then
  GO_VERSION="1.21.5"
  wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
  rm "go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH=$PATH:/usr/local/go/bin
else
  echo "${LBLUE}Go already installed${RESET}"
fi

# Install Go tools
echo "${BLUE}Installing Go packages...${RESET}"
go install github.com/go-delve/delve/cmd/dlv@latest

# Install Gleam
echo "${BLUE}Installing Gleam...${RESET}"
if ! command -v gleam &> /dev/null; then
  GLEAM_VERSION="1.0.0"
  wget "https://github.com/gleam-lang/gleam/releases/download/v${GLEAM_VERSION}/gleam-v${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf "gleam-v${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  sudo mv gleam /usr/local/bin/
  rm "gleam-v${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz"
else
  echo "${LBLUE}Gleam already installed${RESET}"
fi

# Install Deno
echo "${BLUE}Installing Deno...${RESET}"
if ! command -v deno &> /dev/null; then
  curl -fsSL https://deno.land/install.sh | sh
else
  echo "${LBLUE}Deno already installed${RESET}"
fi

# Install Bun
echo "${BLUE}Installing Bun...${RESET}"
if ! command -v bun &> /dev/null; then
  curl -fsSL https://bun.sh/install | bash
else
  echo "${LBLUE}Bun already installed${RESET}"
fi

# Install asdf
echo "${BLUE}Installing asdf...${RESET}"
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
else
  echo "${LBLUE}asdf already installed${RESET}"
fi

# Install fnm and Node.js
echo "${BLUE}Setting up fnm and Node.js...${RESET}"
export PATH="$HOME/.cargo/bin:$PATH"
fnm install --lts
fnm use lts-latest
eval "$(fnm env --use-on-cd --shell bash)"

# Install npm global packages
echo "${BLUE}Installing npm global packages...${RESET}"
npm i -g neovim @nikensss/sauna

# Install ngrok
echo "${BLUE}Installing ngrok...${RESET}"
if ! command -v ngrok &> /dev/null; then
  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
  sudo apt-get update
  sudo apt-get install -y ngrok
else
  echo "${LBLUE}ngrok already installed${RESET}"
fi

# Install Supabase CLI
echo "${BLUE}Installing Supabase CLI...${RESET}"
if ! command -v supabase &> /dev/null; then
  npm install -g supabase
else
  echo "${LBLUE}Supabase already installed${RESET}"
fi

# Install Railway CLI
echo "${BLUE}Installing Railway CLI...${RESET}"
if ! command -v railway &> /dev/null; then
  npm install -g @railway/cli
else
  echo "${LBLUE}Railway already installed${RESET}"
fi

# Install tree-sitter CLI
echo "${BLUE}Installing tree-sitter CLI...${RESET}"
if ! command -v tree-sitter &> /dev/null; then
  npm install -g tree-sitter-cli
else
  echo "${LBLUE}tree-sitter already installed${RESET}"
fi

# Install fx
echo "${BLUE}Installing fx...${RESET}"
if ! command -v fx &> /dev/null; then
  npm install -g fx
else
  echo "${LBLUE}fx already installed${RESET}"
fi

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

mkdir -p ~/repos && cd ~/repos

if [ ! -d ~/repos/vscode-js-debug ]; then
  echo "${GREEN}Installing vscode-js-debug${RESET}"
  cd ~/repos
  git clone git@github.com:microsoft/vscode-js-debug.git
  cd vscode-js-debug
  npm install --legacy-peer-deps
  npx gulp dapDebugServer
  cd ~
fi

if [ ! -d ~/.oh-my-zsh ]; then
  echo "${BLUE}Installing oh-my-zsh${RESET}"
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
else
  echo "${LBLUE}oh-my-zsh already installed${RESET}"
fi

echo "${GREEN}Installing oh-my-zsh plugins${RESET}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo "${LBLUE}zsh-syntax-highlighting already installed${RESET}"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo "${LBLUE}zsh-autosuggestions already installed${RESET}"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode" ]; then
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode
else
  echo "${LBLUE}zsh-vi-mode already installed${RESET}"
fi

echo "${CYAN}Installing power10k theme${RESET}"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "${LBLUE}powerlevel10k already installed${RESET}"
fi

# Return to the dotfiles directory
cd $(dirname "$0")
dir=$(pwd)

olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="tmux.conf tmux.conf.local zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
config="nvim"

mkdir -p $olddir
cd $HOME

echo "${BLUE}Creating symlink for ~/bin${RESET}"
if [ ! -L ~/bin ] && [ ! -d ~/bin ]; then
  ln -s $dir/bin bin
else
  echo "${LBLUE}~/bin already exists${RESET}"
fi

echo "${BLUE}Updating dotfiles${RESET}"
for file in $files; do
  if [ -f ~/.$file ] || [ -L ~/.$file ]; then
    echo "${LBLUE}Backing up $file to $olddir${RESET}"
    mv ~/.$file $olddir/.$file.bak 2>/dev/null || true
  fi
  echo "${CYAN}Creating symlink to $file${RESET}"
  ln -s $dir/$file .$file
done

# symlinks for .config
mkdir -p ~/oldconfig
mkdir -p ~/.config
cd ~/.config

for file in $config; do
  if [ -d $file ] || [ -L $file ]; then
    echo "${LBLUE}Backing up $file to $oldconfig${RESET}"
    mv $file $oldconfig 2>/dev/null || true
  fi
  echo "${CYAN}Creating symlink to $file${RESET}"
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
