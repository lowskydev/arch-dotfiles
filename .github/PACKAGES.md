# Packages

A reference of all packages needed to replicate this setup.
Install `yay` before installing AUR packages (see below).

---

## Before you start

### Install yay (AUR helper)
```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

### Enable multilib (required for NVIDIA 32-bit libs)
Uncomment the `[multilib]` section in `/etc/pacman.conf`, then:
```
sudo pacman -Sy
```

---

## Official packages (pacman)

### Hyprland desktop
| Package | Description |
|---|---|
| `hyprland` | Wayland compositor |
| `hyprpaper` | Wallpaper daemon |
| `hypridle` | Idle daemon |
| `hyprlock` | Screen locker |
| `hyprpolkitagent` | Polkit authentication agent |
| `xdg-desktop-portal-hyprland` | Hyprland XDG portal |
| `xdg-desktop-portal-gtk` | GTK XDG portal fallback |
| `qt5-wayland` | Qt5 Wayland support |
| `qt6-wayland` | Qt6 Wayland support |
| `xorg-xwayland` | XWayland for legacy X11 apps |
| `egl-wayland` | NVIDIA EGL Wayland support |

### Status bar
| Package | Description |
|---|---|
| `waybar` | Status bar |
| `playerctl` | Media player control (used by waybar media module) |

### Terminal and shell
| Package | Description |
|---|---|
| `kitty` | Terminal emulator |
| `zsh` | Shell |
| `starship` | Shell prompt |
| `zsh-autosuggestions` | Fish-like autosuggestions for zsh |
| `zoxide` | Smarter cd command |

### App launcher
| Package | Description |
|---|---|
| `rofi-wayland` | App launcher and dmenu replacement |

### Audio
| Package | Description |
|---|---|
| `pipewire` | Audio server |
| `pipewire-alsa` | ALSA support for PipeWire |
| `pipewire-pulse` | PulseAudio compatibility for PipeWire |
| `pipewire-jack` | JACK compatibility for PipeWire |
| `wireplumber` | PipeWire session manager |
| `pavucontrol` | GUI audio mixer |

### Bluetooth
| Package | Description |
|---|---|
| `bluez` | Bluetooth stack |
| `bluez-utils` | Bluetooth CLI tools |
| `blueman` | Bluetooth manager and tray applet |

### Network
| Package | Description |
|---|---|
| `networkmanager` | Network manager |
| `network-manager-applet` | NetworkManager tray applet |

### Clipboard
| Package | Description |
|---|---|
| `cliphist` | Wayland clipboard manager |
| `wl-clipboard` | Wayland clipboard CLI tools |

### Fonts
| Package | Description |
|---|---|
| `ttf-jetbrains-mono-nerd` | JetBrains Mono with Nerd Font icons |
| `noto-fonts` | Noto fonts |
| `noto-fonts-emoji` | Emoji support |

### NVIDIA drivers (skip if not using NVIDIA)
| Package | Description |
|---|---|
| `nvidia-open` | Open source NVIDIA kernel module |
| `nvidia-utils` | NVIDIA utilities |
| `lib32-nvidia-utils` | 32-bit NVIDIA utilities (requires multilib) |

### Utilities
| Package | Description |
|---|---|
| `xdg-user-dirs` | Manages standard user directories |
| `ufw` | Firewall |
| `ripgrep` | Fast grep (required by Neovim telescope) |
| `tree-sitter-cli` | Tree-sitter CLI (required by Neovim treesitter) |
| `nodejs` | JavaScript runtime (required by Mason LSP servers) |
| `npm` | Node package manager (required by Mason LSP servers) |
| `unzip` | Unzip (required by Mason for clangd) |
| `git` | Version control |
| `base-devel` | Build tools |

### Neovim
| Package | Description |
|---|---|
| `neovim` | Text editor |

---

## AUR packages (yay)

| Package | Description |
|---|---|
| `bibata-cursor-theme` | Cursor theme |
| `tela-icon-theme` | Icon theme |

---

## Post-install steps

### Set zsh as default shell
```
chsh -s $(which zsh)
```

### Enable system services
```
sudo systemctl enable --now bluetooth
sudo systemctl enable --now ufw
sudo systemctl enable fstrim.timer
sudo systemctl enable reflector.timer
```

### Enable user services (PipeWire)
```
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber
```

### UFW firewall rules
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

### NVIDIA — enable DRM kernel mode setting
Add to `/etc/modprobe.d/nvidia.conf`:
```
options nvidia_drm modeset=1 fbdev=1
```

Add to `/etc/mkinitcpio.conf` MODULES array:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Then rebuild initramfs:
```
sudo mkinitcpio -P
```

### Apply icon and GTK theme
```
gsettings set org.gnome.desktop.interface icon-theme "Tela-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
```

### Create standard user directories
```
xdg-user-dirs-update
```

### Install Neovim LSP servers
Open Neovim and run:
```
:Lazy sync
:MasonInstall pyright typescript-language-server bash-language-server json-lsp yaml-language-server dockerfile-language-server html-lsp css-lsp clangd
```
