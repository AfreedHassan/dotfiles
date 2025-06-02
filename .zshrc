
export $(envsubst < ~/.env)
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lh16/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
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

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

export PATH="$HOME/apps/nvim/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
#export TERM=xterm-256color
export TERM=xterm-kitty

function ff() {
  cd ~
  fzf --preview='bat --color=always {}' --bind enter:'become(nvim {})'
}


function fd() {
  cd ~ || return
  fzf \
    --preview='bat --style=numbers --color=always {}' \
    --bind "enter:become(cd \$(dirname {}) && nvim \$(basename {}))"
}


function _fd() {
  # Use fzf to select a file
  local file
  file=$(find . -type f 2>/dev/null | fzf)

  # Exit if nothing selected
  [ -z "$file" ] && return

  # Get directory of the selected file
  local dir
  dir=$(dirname "$file")

  # Ask what to do
  echo "Open directory in:"
  select choice in "File Manager" "Neovim" "Cancel"; do
    case $REPLY in
      1)
        if command -v xdg-open &>/dev/null; then
          xdg-open "$dir"
        elif command -v open &>/dev/null; then
          open "$dir"  # macOS
        elif command -v explorer.exe &>/dev/null; then
          explorer.exe "$(wslpath -w "$dir")"  # WSL
        else
          echo "No suitable file opener found."
        fi
        break
        ;;
      2)
        cd "$dir" && nvim .
        break
        ;;
      3) break ;;
      *) echo "Invalid choice." ;;
    esac
  done
}

alias rofirun="rofi -show drun -theme ~/.config/rofi/launchers/type-1/style-5.rasi"

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
