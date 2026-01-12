#!/usr/bin/env bash

# Ubuntu Setup Script
# This script installs all development tools and packages from Darwin.sh, adapted for Ubuntu
#
# Package Installation Sources:
# - APT (Ubuntu repos): git, curl, wget, zsh, ripgrep, jq, hexedit, tmux, fzf, cmake,
#   exiftool, erlang, rebar3, llvm, boost, gcal, duff, luarocks, tidy, lua, fd-find, bat
# - APT (Official repos): neovim (PPA), httpie, postgresql-16, ngrok
# - NPM: diff-so-fancy, fx, tree-sitter-cli, neovim, @nikensss/sauna, supabase, @railway/cli
# - Cargo: silicon, fnm, hexyl, cargo-nextest, tailspin, nixpacks
# - Snap: sleek
# - Install scripts: Rust, Deno, Bun, pyenv
# - Manual downloads: Go, Gleam
# - Skipped (macOS only): iterm2, xcode-build-server, swiftformat

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

# Neovim PPA for latest version
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# HTTPie official repository
curl -SsL https://packages.httpie.io/deb/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/httpie.gpg 2>/dev/null || true
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/deb ./" | sudo tee /etc/apt/sources.list.d/httpie.list > /dev/null

# PostgreSQL official repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# ngrok official repository
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list

echo "${BLUE}Updating package lists...${RESET}"
sudo apt-get update

echo "${BLUE}Installing core packages via apt...${RESET}"
sudo apt-get install -y \
  curl wget zsh git neovim ripgrep jq hexedit tmux fzf cmake exiftool \
  erlang rebar3 llvm libboost-all-dev gcal duff luarocks tidy \
  lua5.4 liblua5.4-dev luajit libluajit-5.1-dev \
  librsvg2-bin fd-find bat httpie ngrok postgresql-16 \
  build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev unzip ninja-build gettext pkg-config \
  software-properties-common

# Optional: install hexyl and tailspin via apt if Ubuntu 19.10+/24.04+
# Uncomment if you prefer apt over cargo for these tools
# sudo apt-get install -y hexyl 2>/dev/null || echo "hexyl not available via apt, will install via cargo"
# sudo apt-get install -y tailspin 2>/dev/null || echo "tailspin not available via apt, will install via cargo"

# Install tldr (available on Ubuntu 20.04+)
sudo apt-get install -y tldr 2>/dev/null || echo "${YELLOW}tldr not available via apt, will install via npm${RESET}"

# Create symlinks for fd and bat (Ubuntu renames them)
sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
sudo ln -sf $(which batcat) /usr/local/bin/bat 2>/dev/null || true

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

# Install Rust-based tools via Cargo
echo "${BLUE}Installing Rust packages via Cargo...${RESET}"
cargo install --locked \
  silicon \
  fnm \
  hexyl \
  cargo-nextest \
  tailspin \
  nixpacks

# Note: sleek is better installed via snap
echo "${BLUE}Installing sleek via snap...${RESET}"
sudo snap install sleek 2>/dev/null || echo "${YELLOW}Snap not available, skipping sleek${RESET}"

# Install Java 21 (OpenJDK)
echo "${BLUE}Installing Java 21...${RESET}"
if ! java -version 2>&1 | grep -q "version \"21"; then
  sudo apt-get install -y openjdk-21-jdk
  sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
  sudo update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac
else
  echo "${LBLUE}Java 21 already installed${RESET}"
fi

# Install Maven
echo "${BLUE}Installing Maven...${RESET}"
if ! command -v mvn &> /dev/null; then
  sudo apt-get install -y maven
else
  echo "${LBLUE}Maven already installed${RESET}"
fi

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

# Install npm global packages (all in one command for efficiency)
echo "${BLUE}Installing npm global packages...${RESET}"
npm i -g \
  neovim \
  @nikensss/sauna \
  diff-so-fancy \
  fx \
  tree-sitter-cli \
  supabase \
  @railway/cli

# Install tldr via npm if apt version wasn't available
if ! command -v tldr &> /dev/null; then
  echo "${BLUE}Installing tldr via npm...${RESET}"
  npm i -g tldr
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
