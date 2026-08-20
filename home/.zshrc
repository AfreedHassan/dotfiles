HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt extendedglob
setopt prompt_subst
unsetopt beep
bindkey -v

autoload -Uz compinit vcs_info
compinit
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '%b'

precmd() {
  vcs_info
  print -rP "%F{10}%n@%m%f %F{75}%~%f %F{160}${vcs_info_msg_0_}%f "
}
PROMPT='%# '

if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey '^ ' autosuggest-accept
fi

typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n ${key[Home]} ]] && bindkey -- "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey -- "${key[End]}" end-of-line
[[ -n ${key[Insert]} ]] && bindkey -- "${key[Insert]}" overwrite-mode
[[ -n ${key[Backspace]} ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n ${key[Delete]} ]] && bindkey -- "${key[Delete]}" delete-char
[[ -n ${key[Up]} ]] && bindkey -- "${key[Up]}" up-line-or-history
[[ -n ${key[Down]} ]] && bindkey -- "${key[Down]}" down-line-or-history
[[ -n ${key[Left]} ]] && bindkey -- "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey -- "${key[Right]}" forward-char
[[ -n ${key[PageUp]} ]] && bindkey -- "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n ${key[PageDown]} ]] && bindkey -- "${key[PageDown]}" end-of-buffer-or-history
[[ -n ${key[Shift-Tab]} ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete
[[ -n ${key[Control-Left]} ]] && bindkey -- "${key[Control-Left]}" backward-word
[[ -n ${key[Control-Right]} ]] && bindkey -- "${key[Control-Right]}" forward-word

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  zle_application_mode_start() { echoti smkx }
  zle_application_mode_stop() { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

export EDITOR=nvim
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

fopen() {
  local file
  file=$(find "${1:-.}" -type f 2>/dev/null | fzf \
    --preview='bat --style=numbers --color=always {}') || return
  "$EDITOR" "$file"
}

webcam() {
  ffplay -f v4l2 -video_size 640x480 -framerate 30 \
    -vf hflip -fflags nobuffer -flags low_delay -framedrop /dev/video0
}

alias rofirun='rofi -show drun -theme ~/.config/rofi/launcher.rasi'
alias ls='ls -lah --color=auto'

export NVM_DIR="$HOME/.config/nvm"
[[ -s $NVM_DIR/nvm.sh ]] && source "$NVM_DIR/nvm.sh"
[[ -s $NVM_DIR/bash_completion ]] && source "$NVM_DIR/bash_completion"

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
