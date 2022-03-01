#!/usr/bin/env bash

umask g-w,o-w

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

echo "${GREEN}Cloning nikensss/dotfiles...${RESET}"
git clone https://github.com/nikensss/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
git checkout automating

echo "${BLUE}Checking platform${RESET}"
platform=$(uname)
if [ "$platform" = "Linux" ]; then
  echo "${GREEN}Detected Linux${RESET}"
  ./Linux.sh
elif [ "$platform" = "Darwin" ]; then
  echo "${GREEN}Detected macOS${RESET}"
  ./Darwin.sh
fi
