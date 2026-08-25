#!/usr/bin/env bash
# =============================================================================
# Dotfiles Installer — shanks
# Creates symlinks from this repo into the correct locations on a new machine.
# Usage: bash install.sh
# =============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERR]${NC}   $*"; }

# Backup and symlink helper
link() {
    local src="$1"
    local dst="$2"
    local dst_dir
    dst_dir="$(dirname "$dst")"

    mkdir -p "$dst_dir"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing: $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    fi

    ln -s "$src" "$dst"
    success "Linked: $dst → $src"
}

echo ""
echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      Dotfiles Installer — shanks     ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
echo ""

# ── Shell ─────────────────────────────────────────────────────────────────────
info "Linking shell configs..."
link "$DOTFILES_DIR/bash/.bashrc"       "$HOME/.bashrc"
link "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
link "$DOTFILES_DIR/bash/.bash_logout"  "$HOME/.bash_logout"

# ── X11 ───────────────────────────────────────────────────────────────────────
info "Linking X11 configs..."
link "$DOTFILES_DIR/.xinitrc"    "$HOME/.xinitrc"
link "$DOTFILES_DIR/.gtkrc-2.0"  "$HOME/.gtkrc-2.0"

# ── bspwm ─────────────────────────────────────────────────────────────────────
info "Linking bspwm..."
link "$DOTFILES_DIR/bspwm/bspwmrc"              "$CONFIG_DIR/bspwm/bspwmrc"
link "$DOTFILES_DIR/bspwm/lock.sh"              "$CONFIG_DIR/bspwm/lock.sh"
link "$DOTFILES_DIR/bspwm/mac-lock.sh"          "$CONFIG_DIR/bspwm/mac-lock.sh"
link "$DOTFILES_DIR/bspwm/scripts/launch-polybar.sh" "$CONFIG_DIR/bspwm/scripts/launch-polybar.sh"
link "$DOTFILES_DIR/bspwm/scripts/lockscreen.sh"     "$CONFIG_DIR/bspwm/scripts/lockscreen.sh"
link "$DOTFILES_DIR/bspwm/scripts/smart-idle.sh"     "$CONFIG_DIR/bspwm/scripts/smart-idle.sh"
link "$DOTFILES_DIR/bspwm/scripts/smart-lock.sh"     "$CONFIG_DIR/bspwm/scripts/smart-lock.sh"
chmod +x "$DOTFILES_DIR/bspwm/bspwmrc"
chmod +x "$DOTFILES_DIR/bspwm/lock.sh"
chmod +x "$DOTFILES_DIR/bspwm/mac-lock.sh"
chmod +x "$DOTFILES_DIR/bspwm/scripts/"*.sh

# ── sxhkd ─────────────────────────────────────────────────────────────────────
info "Linking sxhkd..."
link "$DOTFILES_DIR/sxhkd/sxhkdrc" "$CONFIG_DIR/sxhkd/sxhkdrc"

# ── Polybar ───────────────────────────────────────────────────────────────────
info "Linking polybar..."
link "$DOTFILES_DIR/polybar/config.ini"         "$CONFIG_DIR/polybar/config.ini"
link "$DOTFILES_DIR/polybar/scripts/wifi.sh"    "$CONFIG_DIR/polybar/scripts/wifi.sh"
link "$DOTFILES_DIR/polybar/scripts/bluetooth.sh" "$CONFIG_DIR/polybar/scripts/bluetooth.sh"
chmod +x "$DOTFILES_DIR/polybar/scripts/"*.sh

# ── Picom ─────────────────────────────────────────────────────────────────────
info "Linking picom..."
link "$DOTFILES_DIR/picom/picom.conf" "$CONFIG_DIR/picom/picom.conf"

# ── Kitty ─────────────────────────────────────────────────────────────────────
info "Linking kitty..."
link "$DOTFILES_DIR/kitty/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"

# ── Dunst ─────────────────────────────────────────────────────────────────────
info "Linking dunst..."
link "$DOTFILES_DIR/dunst/dunstrc" "$CONFIG_DIR/dunst/dunstrc"

# ── Rofi ──────────────────────────────────────────────────────────────────────
info "Linking rofi..."
link "$DOTFILES_DIR/rofi/config.rasi"    "$CONFIG_DIR/rofi/config.rasi"
link "$DOTFILES_DIR/rofi/drun-cyan.rasi" "$CONFIG_DIR/rofi/drun-cyan.rasi"
link "$DOTFILES_DIR/rofi/launcher.rasi"  "$CONFIG_DIR/rofi/launcher.rasi"
link "$DOTFILES_DIR/rofi/powermenu.rasi" "$CONFIG_DIR/rofi/powermenu.rasi"
link "$DOTFILES_DIR/rofi/theme.rasi"     "$CONFIG_DIR/rofi/theme.rasi"
link "$DOTFILES_DIR/rofi/powermenu/powermenu-cyan.rasi" "$CONFIG_DIR/rofi/powermenu/powermenu-cyan.rasi"
link "$DOTFILES_DIR/rofi/powermenu/powermenu.sh"        "$CONFIG_DIR/rofi/powermenu/powermenu.sh"
for icon in "$DOTFILES_DIR/rofi/powermenu/icons/"*.svg; do
    fname="$(basename "$icon")"
    link "$icon" "$CONFIG_DIR/rofi/powermenu/icons/$fname"
done
link "$DOTFILES_DIR/rofi/scripts/btmenu.sh"    "$CONFIG_DIR/rofi/scripts/btmenu.sh"
link "$DOTFILES_DIR/rofi/scripts/powermenu.sh" "$CONFIG_DIR/rofi/scripts/powermenu.sh"
link "$DOTFILES_DIR/rofi/scripts/wifimenu.sh"  "$CONFIG_DIR/rofi/scripts/wifimenu.sh"
chmod +x "$DOTFILES_DIR/rofi/powermenu/powermenu.sh"
chmod +x "$DOTFILES_DIR/rofi/scripts/"*.sh

# ── GTK ───────────────────────────────────────────────────────────────────────
info "Linking GTK..."
link "$DOTFILES_DIR/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-3.0/settings.ini"
link "$DOTFILES_DIR/gtk-3.0/gtk.css"      "$CONFIG_DIR/gtk-3.0/gtk.css"

# ── System monitors ───────────────────────────────────────────────────────────
info "Linking htop & btop..."
link "$DOTFILES_DIR/htop/htoprc"    "$CONFIG_DIR/htop/htoprc"
link "$DOTFILES_DIR/btop/btop.conf" "$CONFIG_DIR/btop/btop.conf"

# ── Screen layout ─────────────────────────────────────────────────────────────
info "Linking screenlayout..."
link "$DOTFILES_DIR/screenlayout/LG_MONITOR.sh" "$HOME/.screenlayout/LG_MONITOR.sh"
chmod +x "$DOTFILES_DIR/screenlayout/LG_MONITOR.sh"

# ── Wallpaper ─────────────────────────────────────────────────────────────────
info "Installing wallpaper..."
mkdir -p "$HOME/Pictures/wallpapers"
cp "$DOTFILES_DIR/wallpapers/wallpaper.jpg" "$HOME/Pictures/wallpapers/wallpaper.jpg"
success "Wallpaper copied to ~/Pictures/wallpapers/wallpaper.jpg"

# ── Package installation (optional) ──────────────────────────────────────────
echo ""
echo -e "${YELLOW}Install packages from pkglist?${NC}"
echo "  [1] Install official repo packages  (sudo pacman -S)"
echo "  [2] Install AUR packages            (yay -S)"
echo "  [3] Install both"
echo "  [s] Skip"
read -rp "Choice [1/2/3/s]: " pkg_choice

case "$pkg_choice" in
    1|3)
        info "Installing official packages..."
        # strip comments and blank lines
        grep -v '^\s*#' "$DOTFILES_DIR/pkglist/pkgs_pacman.txt" | grep -v '^\s*$' | \
            sudo pacman -S --needed -
        success "Official packages installed."
        ;&
    2|3)
        if ! command -v yay &>/dev/null; then
            warn "yay not found. Install it first: https://github.com/Jguer/yay"
        else
            info "Installing AUR packages..."
            grep -v '^\s*#' "$DOTFILES_DIR/pkglist/pkgs_aur.txt" | grep -v '^\s*$' | \
                yay -S --needed -
            success "AUR packages installed."
        fi
        ;;
    *) info "Skipping package installation." ;;
esac

echo ""
echo -e "${GREEN}✔ All done! Log out and back in (or run: exec bspwm) to apply.${NC}"
echo ""
