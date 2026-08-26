# Dotfiles

Portable Arch Linux configuration for Hyprland, Waybar, Vicinae, Rofi,
Foot, Kitty, Dunst, Satty, Zsh, Tmux, Vim, and btop. Neovim is intentionally unmanaged.
The installer rebuilds Fontconfig caches after package installation to avoid
Qt crashes caused by stale font metadata.

## Install

On a fresh Arch installation:

```bash
sudo pacman -S --needed git
git clone https://github.com/AfreedHassan/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The installer updates official packages, installs AUR packages with `paru`,
backs up conflicting files with a timestamp, and creates symlinks. It is safe
to run again. Fixedsys Excelsior Mono is downloaded from
`AfreedHassan/FixedsysExcelsiorMono` at a pinned commit and verified before it
is installed.

Preview changes or install only configuration files:

```bash
~/.dotfiles/install.sh --dry-run
~/.dotfiles/install.sh --skip-packages
```

## Machine-specific setup

The tracked Hyprland configuration uses automatic monitor detection. Put
host-specific Hyprland settings in `~/.config/hypr/local.conf`; that file is
ignored by Git.

Hyprpaper is intentionally host-local because monitor names and wallpaper
paths differ. Create `~/.config/hypr/hyprpaper.conf` after installation:

```ini
wallpaper {
    monitor =
    path = ~/Pictures/wallpaper.jpg
    fit_mode = cover
}
```

Set your Git identity in the untracked local include after installation:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

Install Tmux plugins by starting Tmux and pressing `Ctrl-s`, then `I`.

## Key bindings

- `Super+Space`: Vicinae
- `Super+M`: lock with Hyprlock
- `Super+R`: Hyprlauncher
- `Super+C`: Rofi calculator
- `Super+Print`: region screenshot to clipboard
- `Super+Shift+Print`: region screenshot with Satty annotation
- `Caps Lock+Print`: region screenshot with Satty annotation
- `Super+B`: restart Waybar

In Satty, use `T` for text, `M` for numbered markers, `Z` for arrows, and
`U` for blur. Press `Enter` to copy the result and exit, or `Ctrl+S` to save
it under `~/Pictures/Screenshots/`.

## Fingerprint login

The ThinkPad T480 Synaptics `06cb:009a` reader uses `python-validity`,
`open-fprintd`, and `fprintd-clients-git`; it is not supported by upstream
`libfprint` alone. After the normal installer finishes, enroll and verify a
fingerprint, then enable fingerprint login for Ly:

```bash
sudo ~/.dotfiles/scripts/setup-fingerprint.sh
```

The setup script backs up `/etc/pam.d/ly`, verifies the fingerprint before
changing PAM, and retains password fallback. Fingerprint authentication is not
enabled for `sudo` or polkit.

## Security

This repository deliberately excludes environment files, shell histories,
SSH/GPG material, browser profiles, application sessions, and authentication
state. Keep secrets in an ignored `~/.env` or a password manager, never in
this repository.
