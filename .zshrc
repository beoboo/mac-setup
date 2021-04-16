DISABLE_MAGIC_FUNCTIONS="true"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home/"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Path to your oh-my-zsh installation.
export ZSH=/Users/pietrino.atzeni/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="avit"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  brew
  docker
  npm
  osx
  bgnotify
  history
  zsh-syntax-highlighting
  zsh-autosuggestions
  sudo
  web-search
)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias gpf='git push -f'

# Docker alias
alias dkps="docker ps"
alias dkst="docker stats"
alias dkpsa="docker ps -a"
alias dkimgs="docker images"
alias dkcpup="docker-compose up -d"
alias dkcpdown="docker-compose down"
alias dkcpstart="docker-compose start"
alias dkcpstop="docker-compose stop"

# Kubectl alias
alias kdev='kubectl -n dev'
alias kpg='kubectl -n playground'
alias ktest='kubectl -n test'
alias kprod='kubectl -n prod'
alias kpreprod='kubectl -n preprod'

# custom aliases
alias wa='watch -n1 '
alias kl='kubectl'
alias tf='terraform'
alias zsu='source ~/.zshrc'

alias pib='pipeline-builder'

export GOPATH=$HOME/go

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION='$P9K_KUBECONTEXT_NAME:$P9K_KUBECONTEXT_NAMESPACE'
#typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='('
#typeset -g POWERLEVEL9K_KUBECONTEXT_SUFFIX=')'
#typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='⎈'
#p10k reload

#function powerline_precmd() {
#    PS1="$($GOPATH/bin/powerline-go -error $? -jobs ${${(%):%j}:-0})"
#
#    # Uncomment the following line to automatically clear errors after showing
#    # them once. This not only clears the error for powerline-go, but also for
#    # everything else you run in that shell. Don't enable this if you're not
#    # sure this is what you want.
#    
#    #set "?"
#}
#
#function install_powerline_precmd() {
#  for s in "${precmd_functions[@]}"; do
#    if [ "$s" = "powerline_precmd" ]; then
#      return
#    fi
#  done
#  precmd_functions+=(powerline_precmd)
#}
#
#if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
#    install_powerline_precmd
#fi

. /usr/local/opt/asdf/asdf.sh

. /usr/local/etc/profile.d/z.sh

eval "$(direnv hook zsh)"
export PATH="/usr/local/sbin:$PATH"

awslogin() {
    local TOKEN=$1
    local PROFILE=${2:-$USER}
    echo "Logging in AWS with $PROFILE:$TOKEN"
    eval $(plumberkit aws login pietrino.atzeni $TOKEN)
    echo $AWS_SESSION_TOKEN
}

ecrlogin() {
    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 537084507879.dkr.ecr.eu-west-1.amazonaws.com
}

flylogin() {
    echo "Logging in Concourse team $1"
    fly -t $1 login -c http://cd.moneyfarm.com -n $1
}

alias gitlab_config='sed -i"" -e"s/git.moneyfarm.com:/gitlab.com:moneyfarm-tech\//" .git/config'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

source <(kubectl completion zsh)
complete -F __start_kubectl kl

eval "$(direnv hook zsh)"
#compdef pipeline-builder
_pipeline-builder() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPELINE_BUILDER_COMPLETE=complete-zsh  _CLICK_COMPLETION_COMMAND_CASE_INSENSITIVE_COMPLETE=ON pipeline-builder)
}
if [[ "$(basename -- ${(%):-%x})" != "_pipeline-builder" ]]; then
  compdef _pipeline-builder pipeline-builder
fi

VIRTUAL_ENV_DISABLE_PROMPT=1
