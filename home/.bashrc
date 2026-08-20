[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export EDITOR=nvim
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
