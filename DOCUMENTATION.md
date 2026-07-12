# ArcXos Linux Developer & System Documentation

This documentation provides an in-depth guide on how the ArcXos build profiles are structured, customized, and maintained. It is intended for developers who wish to customize the ISO, update the theme, modify default packages, or configure post-installation parameters.

---

## 🏗️ System & Build Architecture

ArcXos uses the `archiso` framework to compile a bootable live ISO. The build configuration is organized into standard directory layouts:

- `airootfs/`: Contains filesystem overlays. Any file placed here is copied to its relative location on the live target filesystem (e.g. `airootfs/etc/shadow` goes to `/etc/shadow`).
- `efiboot/`: Configures UEFI boot manager (`systemd-boot`) settings and boot options.
- `syslinux/`: Configures MBR bootloader (`syslinux` / `isolinux`) configurations.
- `packages.x86_64`: Flat list of packages to install on the live ISO.
- `pacman.conf`: Customized Pacman configuration enabling the BlackArch repositories.
- `profiledef.sh`: Main script defining metadata (labels, name, publisher, boot modes) and explicit file/directory ownership/permissions.

---

## ⚙️ Configuration Deep-Dive

### 1. File Permissions (`profiledef.sh`)
Permissions for sensitive configuration files must be explicitly configured in `profiledef.sh` inside the `file_permissions` array. For example:

```bash
file_permissions=(
  ["/etc/shadow"]="0:0:0400"
  ["/etc/gshadow"]="0:0:0400"
  ["/etc/sudoers.d"]="0:0:0750"
  ["/root"]="0:0:0700"
  ["/root/customize_airootfs.sh"]="0:0:0755"
)
```

Ensure all executable scripts in `airootfs` (such as hooks or custom startup routines) are defined with executable permissions (`0755`).

### 2. Live Environment Setup (`customize_airootfs.sh`)
The file `airootfs/root/customize_airootfs.sh` executes in a chroot environment during the final phase of building the ISO. It handles:

- **Locale & Timezone**: Generates `en_US.UTF-8` and links the UTC timezone.
- **Repository Bootstrap**: Downloads and runs the BlackArch strap installer to initialize security repository keyrings.
- **User Setup**: 
  - Overwrites root password: `root:arcx`
  - Adds the default session user: `liveuser` (password: `arcx`), assigned to standard user groups (`wheel`, `audio`, `video`, etc.) with `zsh` as default shell.
  - Adds install-menu and launcher icons on the desktop.
- **Desktop Customizations**: Searches for and replaces all occurrences of default wallpaper references in configuration files (`xfce4-desktop.xml`) with the custom `background.png`.

---

## 🎨 Aesthetic & Wallpaper Customization

ArcXos features a variety of curated high-quality wallpapers. They are placed in:
- `airootfs/usr/share/backgrounds/`

### How to Change the Default Wallpaper
To change the default wallpaper shown upon boot:
1. Put your custom image in `airootfs/usr/share/backgrounds/`.
2. Update the symlink or name to `background.png`, or edit `customize_airootfs.sh` to target your custom wallpaper name.
3. During the ISO build process, `customize_airootfs.sh` will scan all desktop configs and patch the path to target this wallpaper.

---

## 📦 Managing Packages

To add or remove packages from the ArcXos ISO:
1. Open [packages.x86_64](file:///home/arunachalam/blackarch-iso/slim-iso/packages.x86_64).
2. To **add** a package: Add the exact package name on a new line.
3. To **remove** a package: Delete the line or comment it out with `#`.
4. Ensure the required core packages (`mkinitcpio` and `mkinitcpio-archiso`) are always kept.

---

## 🚀 Boot Configurations

Boot configs are separated by boot mode:
- **UEFI Boot loader entries**: Located in `efiboot/loader/entries/`. You can edit boot parameters (like `cow_spacesize=10G` or copytoram options) in `archiso-x86_64-linux.conf`.
- **BIOS Boot loader configs**: Located in `syslinux/`. Custom kernel flags can be added in `archiso_sys-linux.cfg`.
