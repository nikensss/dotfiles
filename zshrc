# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NODE_ENV=mbp
export VISUAL=vim
export EDITOR="$VISUAL"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
 git
 zsh-syntax-highlighting
 zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# alias ohmyzsh="mate ~/.oh-my-zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#aliases
alias py=python
alias mongodefault='mongod --config /usr/local/etc/mongod.conf'
alias balenaEtcher='sudo /Applications/balenaEtcher.app/Contents/MacOS/balenaEtcher'
alias usevenv='source venv/bin/activate'
alias t='npm test'
alias tw='npm run test:watch'
alias s='npm start'
alias please='sudo'
alias up='cd ..'
alias repos='cd ~/repos'
alias weirwood='repos && cd weirwood'
alias ww='weirwood'
alias js='repos && cd javascript'
alias vzsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias quokka='code ~/repos/javascript/quokkasandbox'
alias sass-watch='sass --watch --no-source-map scss/style.scss css/style.css'
alias postcss-watch='postcss css/style.css -o css/output.css --no-map -u autoprefixer -w'
alias rmnm='rm -rf node_modules'

cln(){
  git clone $1
  code "$(basename "$1" .git)"
}

mcd () {
  mkdir -p $1
  cd $1
}

lpmh () {
  #babel
  npm i -D @babel/eslint-parser @babel/preset-env @babel/plugin-proposal-class-properties
  #eslint
  npm i -D eslint eslint-config-prettier eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-prettier@latest eslint-plugin-promise
  #prettier
  npm i -D --save-exact prettier
  #husky and commitlint
  npm i -D husky@4 @commitlint/cli @commitlint/config-conventional
  #mocha and chai
  npm i -D mocha chai

  echo '{
  "env": {
      "es2021": true,
      "node": true,
      "mocha": true
    },
    "extends": ["standard", "plugin:prettier/recommended"],
    "parser": "@babel/eslint-parser",
    "parserOptions": {
      "ecmaVersion": 12,
      "sourceType": "module"
    },
    "rules": {}
  }' > .eslintrc.json

  echo '{
    "tabWidth": 2,
    "useTabs": false,
    "semi": true,
    "singleQuote": true,
    "trailingComma": "none",
    "arrowParens": "avoid"
  }' > .prettierrc.json

  echo '{
    "extends": ["@commitlint/config-conventional"]
  }' > .commitlintrc.json

  echo '{
    "presets": ["@babel/preset-env"],
    "plugins": ["@babel/plugin-proposal-class-properties"]
  }' > .babelrc.json

  echo '{
    "diff": true,
    "extension": ["js"],
    "package": "./package.json",
    "recursive": true,
    "spec": ["test/**/*.spec.js"]
  }' > .mocharc.json
}
