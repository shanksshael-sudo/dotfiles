# 🌌 shanks' dotfiles

> **bspwm · polybar · picom · kitty · rofi · dunst**  
> Dark cyan aesthetic — `#00f5ff` on `#0a0a0f`

---

## 📦 Stack

| Category        | Tool                        |
|-----------------|-----------------------------|
| Window Manager  | bspwm                       |
| Hotkeys         | sxhkd                       |
| Bar             | Polybar                     |
| Compositor      | Picom (glx, blur, rounded)  |
| Terminal        | Kitty                       |
| Notifications   | Dunst                       |
| Launcher        | Rofi                        |
| Wallpaper       | feh                         |
| Shell           | Bash                        |
| GTK Theme       | Materia-dark                |
| Icons           | Papirus-Dark                |
| Font            | JetBrainsMono Nerd Font     |

---

## 🗂 Repository Structure

```
dotfiles/
├── install.sh                  ← bootstrap (creates symlinks)
├── .xinitrc                    ← X11 startup (launches bspwm)
├── .gtkrc-2.0                  ← GTK2 theme
├── bash/
│   ├── .bashrc
│   ├── .bash_profile
│   └── .bash_logout
├── bspwm/
│   ├── bspwmrc                 ← main WM config
│   ├── lock.sh
│   ├── mac-lock.sh
│   └── scripts/
│       ├── launch-polybar.sh
│       ├── lockscreen.sh
│       ├── smart-idle.sh
│       └── smart-lock.sh
├── sxhkd/
│   └── sxhkdrc                 ← all keybindings
├── polybar/
│   ├── config.ini
│   └── scripts/
│       ├── wifi.sh
│       └── bluetooth.sh
├── picom/
│   └── picom.conf              ← shadows, blur, fading, rounded corners
├── kitty/
│   └── kitty.conf              ← colors, font, opacity, tabs
├── dunst/
│   └── dunstrc                 ← notification style
├── rofi/
│   ├── config.rasi
│   ├── theme.rasi
│   ├── launcher.rasi
│   ├── drun-cyan.rasi
│   ├── powermenu.rasi
│   ├── powermenu/
│   │   ├── powermenu-cyan.rasi
│   │   ├── powermenu.sh
│   │   └── icons/
│   └── scripts/
│       ├── wifimenu.sh
│       ├── btmenu.sh
│       └── powermenu.sh
├── gtk-3.0/
│   ├── settings.ini
│   └── gtk.css
├── htop/
│   └── htoprc
├── btop/
│   └── btop.conf
└── screenlayout/
    └── LG_MONITOR.sh           ← xrandr layout for external LG monitor
```

---

## 🚀 Installation

### 1. Install dependencies (Arch / Manjaro)

```bash
sudo pacman -S bspwm sxhkd polybar picom kitty dunst rofi feh \
               papirus-icon-theme materia-gtk-theme \
               ttf-jetbrains-mono-nerd
```

### 2. Clone the repo

```bash
git clone https://github.com/shanksshael-sudo/dotfiles.git ~/dotfiles
```

### 3. Run the installer

```bash
cd ~/dotfiles
bash install.sh
```

The installer will:
- **Back up** any existing files as `<file>.bak`
- **Create symlinks** from `~/dotfiles/` into the correct `~/.config/` locations
- **Set execute permissions** on all scripts automatically

### 4. Start bspwm

Log out and back in, or from a TTY:
```bash
startx
```

---

## 🎨 Color Palette

| Role           | Hex       |
|----------------|-----------|
| Background     | `#0a0a0f` |
| Surface        | `#1a1a2e` |
| Accent / Cyan  | `#00f5ff` |
| Foreground     | `#e0e0e0` |
| Red (urgent)   | `#ff4466` |
| Green          | `#00ff88` |
| Yellow         | `#ffcc00` |
| Purple         | `#cc44ff` |

---

## 🖥 Multi-Monitor Setup

Supports dual monitors (**HDMI1** + **LVDS1**):
- `HDMI1` → workspaces **1–5**
- `LVDS1` → workspaces **6–10**

Single-monitor falls back gracefully — all 10 workspaces go to `LVDS1`.  
Adjust `screenlayout/LG_MONITOR.sh` with your own `xrandr` command.

---

## 📝 Notes

- Wallpaper is loaded from `~/Pictures/wallpapers/wallpaper.jpg` and is included in this repo under `wallpapers/`. The installer copies it automatically.
- Kitty background opacity is `0.8`, further blurred by picom.
- `smart-idle.sh` auto-locks on idle — adjust the timeout inside the script.
- Border / accent color is `#00f5ff`. Change in `bspwm/bspwmrc` and `kitty/kitty.conf`.

---

## 📜 License

MIT — do whatever you want with it.
