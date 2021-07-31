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

# install developer tools
echo "${GREEN}installing delevoper tools...${RESET}"
xcode-select --install

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# install homebrew
echo "${GREEN}installing homebrew${RESET}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install iterm2
brew install iterm2

# install nvim
brew install neovim

# install oh-my-zsh
echo "${BLUE}installing oh-my-zsh${RESET}"
sh -c "$(curl https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended

echo "${BLUE}installing plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "${CYAN}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# variables
dir=$HOME/dotfiles
olddir=$HOME/dotfiles_old
oldconfig=$HOME/oldconfig
files="vimrc zshrc p10k.zsh zsh_aliases zsh_functions gitconfig"
config="nvim"

# create backup folder
mkdir -p $olddir
# move to dotfiles folder
cd $HOME

echo "${BLUE}updating dotfiles${RESET}"
for file in $files; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv ~/.$file $olddir
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file .$file
done

# symlinks for .config
mkdir ~/oldconfig
mkdir ~/.config
cd ~/.config

for file in $config; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv .$file $oldconfig
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file $file
echo "${GREEN}We are done! 🥳${RESET}"

# after creating the symlink to vimrc, install plugins with
nvim +'PlugInstall --sync' +qa

# change to zsh
echo "${YELLOW}changing shell...${RESET}"
zsh=$(command -v zsh)
if ! chsh -s "$zsh"; then
  fmt_error "chsh command unsuccessful. Change your default shell manually."
else
  export SHELL="$zsh"
  echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
fi

exec zsh -l
