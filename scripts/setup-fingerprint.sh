#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
target_user=${SUDO_USER:-${1:-}}

if ((EUID != 0)); then
  printf 'Run this script with sudo.\n' >&2
  exit 1
fi

if [[ -z $target_user || $target_user == root ]]; then
  printf 'Could not determine the non-root user to enroll.\n' >&2
  exit 1
fi

if ! lsusb | grep -q '06cb:009a'; then
  printf 'Expected ThinkPad T480 fingerprint reader 06cb:009a was not found.\n' >&2
  exit 1
fi

for command in fprintd-enroll fprintd-verify; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf '%s is missing. Run the dotfiles installer first.\n' "$command" >&2
    exit 1
  fi
done

systemctl enable --now python3-validity.service
systemctl enable open-fprintd-resume.service open-fprintd-suspend.service

printf 'Enroll a fingerprint for %s. The right index finger is the default.\n' "$target_user"
fprintd-enroll "$target_user"

printf 'Verify the enrolled fingerprint before enabling login authentication.\n'
fprintd-verify "$target_user"

if [[ -e /etc/pam.d/ly && ! -e /etc/pam.d/ly.pre-dotfiles ]]; then
  cp --preserve=mode,ownership,timestamps /etc/pam.d/ly /etc/pam.d/ly.pre-dotfiles
fi
install -Dm644 "$repo_dir/system/pam/ly" /etc/pam.d/ly

printf '\nFingerprint login is enabled for Ly and Hyprlock.\n'
printf 'Password authentication remains available as a fallback.\n'
