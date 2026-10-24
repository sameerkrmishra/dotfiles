[[ -f ~/shell_secrets ]] && source ~/shell_secrets

# --- PATH & environment ---
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH=/usr/lib/jvm/java-26-openjdk/bin:$PATH
export PAGER=less LESS=-R

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history

# --- General options ---
setopt auto_cd auto_pushd pushd_ignore_dups pushdminus
setopt interactive_comments long_list_jobs multios prompt_subst
unsetopt flow_control

# --- Colors & aliases ---
[[ -z $LS_COLORS ]] && eval "$(dircolors -b)"
alias ls='ls --color=tty'
alias grep='grep --color=auto'
alias l='ls -lah' ll='ls -lh' la='ls -lAh'
alias ...='../..' ....='../../..'
alias lisp=sbcl
alias mountuser="sudo mount -o uid=$(id -u),gid=$(id -g),umask=022"

# --- Completion ---
autoload -Uz compinit && compinit
zmodload zsh/complist
setopt auto_menu complete_in_word always_to_end
WORDCHARS=''
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh

# --- Key bindings (emacs mode) ---
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line '^[OH' beginning-of-line '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line       '^[OF' end-of-line       '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word '^[[1;5D' backward-word
bindkey '^[[Z' reverse-menu-complete

# --- Prompt (robbyrussell look) ---
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '*'
zstyle ':vcs_info:git:*' formats '%b|%u%c'
zstyle ':vcs_info:git:*' actionformats '%b|%u%c'
_prompt_git() {
  vcs_info
  local branch=${vcs_info_msg_0_%%|*} dirty=${vcs_info_msg_0_#*|}
  if [[ -z $vcs_info_msg_0_ ]]; then
    _git_prompt=''
  elif [[ -n $dirty ]]; then
    _git_prompt=" %B%F{blue}git:(%F{red}${branch}%F{blue}) %F{yellow}✗%f%b"
  else
    _git_prompt=" %B%F{blue}git:(%F{red}${branch}%F{blue})%f%b"
  fi
}
precmd_functions+=(_prompt_git)
PROMPT='%B%(?:%F{green}:%F{red})➜%f%b  %F{cyan}%c%f${_git_prompt} '

# Terminal title: "user@host: dir"
_set_title() { print -Pn '\e]2;%n@%m: %~\a' }
precmd_functions+=(_set_title)

# --- Plugins ---
source <(fzf --zsh)
for f in /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
         ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -r $f ]] && source $f && break
done
unset f

# --- opam ---
[[ ! -r '/home/sameer/.opam/opam-init/init.zsh' ]] || source '/home/sameer/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
