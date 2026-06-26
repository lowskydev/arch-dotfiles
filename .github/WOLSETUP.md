# Wake on LAN Setup

Setup for RTL8126 NIC on MSI MAG B850 TOMAHAWK MAX WIFI.

---

## Packages

| Package      | Description                                     |
| ------------ | ----------------------------------------------- |
| `ethtool`    | NIC query and configuration tool                |
| `r8126-dkms` | Realtek RTL8126 5GbE driver with WoL S5 support |

Install:

```
sudo pacman -S ethtool
yay -S r8126-dkms
```

---

## BIOS Settings

Enter BIOS and configure:

- ErP Ready -> Disabled
- Wake Up Event By -> BIOS
- Resume By PCIE Device -> Enabled

---

## Driver Configuration

Create `/etc/modprobe.d/r8126.conf`:

```
blacklist r8169
options r8126 s5wol=1 s0_magic_packet=1 disable_wol_support=0
```

Rebuild initramfs:

```
sudo mkinitcpio -P
```

---

## NetworkManager

Enable WoL via NetworkManager (persists across reboots):

```
nmcli connection modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic
nmcli device reapply enp8s0
```

Verify:

```
sudo ethtool enp8s0 | grep Wake
```

Expected output: `Wake-on: g`

---

## Verify Driver

After reboot, confirm the correct driver is loaded:

```
lspci -k | grep -A3 "Ethernet"
```

Expected: `Kernel driver in use: r8126`

---

## Notes

- WoL only works with Wake Up Event By set to BIOS mode - OS mode is broken due to a firmware bug (PME-Enable bit is actively cleared by the BIOS, preventing the OS from setting it)
