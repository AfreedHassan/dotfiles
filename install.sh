#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
dry_run=false
skip_packages=false

usage() {
  printf 'Usage: %s [--dry-run] [--skip-packages]\n' "$0"
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --skip-packages) skip_packages=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 1 ;;
  esac
done

run() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
  if [[ $dry_run == false ]]; then
    "$@"
  fi
}

read_package_file() {
  local file=$1
  local -n result=$2
  local line

  while IFS= read -r line || [[ -n $line ]]; do
    line=${line%%#*}
    line=${line//[[:space:]]/}
    [[ -n $line ]] && result+=("$line")
  done < "$file"
}

install_packages() {
  if [[ ! -f /etc/arch-release ]]; then
    printf 'Package installation is only supported on Arch Linux.\n' >&2
    exit 1
  fi

  local official=()
  local aur=()
  read_package_file "$repo_dir/packages/pacman.txt" official
  read_package_file "$repo_dir/packages/aur.txt" aur

  run sudo pacman -Syu --needed "${official[@]}"

  if ! command -v paru >/dev/null 2>&1; then
    local build_dir
    build_dir=$(mktemp -d)
    run git clone https://aur.archlinux.org/paru.git "$build_dir/paru"
    if [[ $dry_run == false ]]; then
      (cd "$build_dir/paru" && makepkg -si)
      rm -rf -- "$build_dir"
    fi
  fi

  if ((${#aur[@]})); then
    run paru -S --needed "${aur[@]}"
  fi

  run fc-cache -f
}

link_path() {
  local source=$1
  local target=$2
  local backup

  if [[ -L $target && $(readlink -f -- "$target") == $(readlink -f -- "$source") ]]; then
    printf 'Already linked: %s\n' "$target"
    return
  fi

  run mkdir -p -- "$(dirname -- "$target")"
  if [[ -e $target || -L $target ]]; then
    backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
    run mv -- "$target" "$backup"
  fi
  run ln -s -- "$source" "$target"
}

if [[ $skip_packages == false ]]; then
  install_packages
fi

for file in .bash_profile .bashrc .gitconfig .tmux.conf .vimrc .zshrc; do
  link_path "$repo_dir/home/$file" "$HOME/$file"
done

for directory in btop foot hypr kitty rofi vicinae waybar; do
  link_path "$repo_dir/config/$directory" "$HOME/.config/$directory"
done

if [[ ! -e $repo_dir/config/hypr/local.conf ]]; then
  run touch "$repo_dir/config/hypr/local.conf"
fi

if [[ ! -e $repo_dir/config/hypr/hyprpaper.conf ]]; then
  run cp "$repo_dir/config/hypr/hyprpaper.example.conf" \
    "$repo_dir/config/hypr/hyprpaper.conf"
fi

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  run git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

printf '\nDotfiles installed. Log out and back in after changing your login shell.\n'
if [[ ${SHELL:-} != */zsh ]]; then
  printf 'Optional: chsh -s "$(command -v zsh)"\n'
fi
