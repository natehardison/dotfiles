# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(autojump brew git heroku npm)

source $ZSH/oh-my-zsh.sh

# Set up virtualenvwrapper
if $(which -s virtualenvwrapper.sh); then
    export PROJECT_HOME=$HOME/src
    source `which virtualenvwrapper.sh`
fi

system=$(uname -s)
case $system in
    Darwin)
        # Set up proper bin/ dir ordering on PATH
        export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

        # Add Postgres.app to PATH, if present
        if [ -d "/Applications/Postgres.app" ]; then
            export PATH=/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH
        fi
        ;;
    *)
        ;;
esac

export HOMEBREW_GITHUB_API_TOKEN="24c945d2285a3c13b33a4760b65ea7515af848c7"
