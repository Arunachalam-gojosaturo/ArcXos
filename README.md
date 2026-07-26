# <p align="center"><img src="slim-iso/airootfs/usr/share/backgrounds/arcxoslogo.png" alt="ArcXos Logo" width="220"/><br>ArcXos Linux</p>

<p align="center">
  <a href="https://archlinux.org"><img src="https://img.shields.io/badge/Base-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" alt="Arch Linux Base"/></a>
  <a href="https://blackarch.org"><img src="https://img.shields.io/badge/Security-BlackArch_Repo-800000?style=for-the-badge&logo=gnu-linux&logoColor=white" alt="BlackArch Repo"/></a>
  <a href="#"><img src="https://img.shields.io/badge/Arch-x86__64-brightgreen?style=for-the-badge&logo=cpu" alt="x86_64"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge" alt="GPL-3.0"/></a>
</p>

---

## 🛡️ Overview

**ArcXos Linux** is a high-performance, lightweight, and custom-tailored security auditing, ethical hacking, and penetration testing distribution built on top of **Arch Linux** and **BlackArch Linux**.

Designed for security professionals, red teamers, malware analysts, and security enthusiasts, ArcXos delivers a fast, stable desktop experience with custom cybersecurity wallpapers, custom GUI/CLI installers, modular build profiles, and curated tool suites.

---

## ✨ Key Features

- **🚀 Customized Desktop Environments**: LightDM GTK greeter with XFCE4, Awesome WM, and Openbox desktop configurations.
- **🎨 Custom Cyber Aesthetics**: Includes exclusive custom ArcXos wallpapers, dark themes, custom icons, and automated wallpaper setting scripts.
- **🛠️ Integrated Installers**: Built-in CLI and GUI installers (`arcxos-installer`, `arcxos-gui-installer`) for easy installation.
- **📦 Modular Distribution Profiles**:
  - **Slim Edition (`slim-iso`)**: Fast & lightweight footprint featuring XFCE4, LightDM, and essential pentesting suites.
  - **Selective Edition (`selective-iso`)**: Specialized environment equipped with modular deployment scripts for top enterprise security suites.
  - **Full Edition (`full-iso`)**: Complete security suite containing the entire BlackArch repository toolset out-of-the-box.
  - **Netinstall Edition (`netinstall-iso`)**: Minimal network bootstrap installer ISO profile.
- **⚡ Optimized Live System**: Configured with `cow_spacesize=10G`, zsh defaults, and automatic BlackArch keyring initialization.

---

## 📦 Edition Comparison Matrix

| Feature / Edition | Slim Edition (`slim-iso`) | Selective Edition (`selective-iso`) | Full Edition (`full-iso`) | Netinstall (`netinstall-iso`) |
| :--- | :---: | :---: | :---: | :---: |
| **Desktop Environment** | XFCE4 + LightDM | XFCE4 + LightDM | XFCE4 / Openbox | CLI / Minimal |
| **Target Use Case** | Fast Audits & Live Use | Enterprise & Custom Suites | Complete PenTesting | Custom Network Installs |
| **Tool Footprint** | Essential Pentesting | Modular / Category Scripts | 2800+ BlackArch Tools | Minimal Bootstrap |
| **Installers Included** | GUI + CLI Installer | Modular Setup + CLI | Standard Archiso | Netinstall Bootstrap |
| **Recommended Storage** | 16 GB+ | 32 GB+ | 64 GB+ | 10 GB+ |

---

## 📂 Repository Structure

```
ArcXos/
├── slim-iso/           # Slim ISO Edition (XFCE4 + LightDM + Essential Pentesting Tools)
│   ├── airootfs/       # Target filesystem overlay (/etc, /root, /usr, /usr/share/backgrounds)
│   ├── efiboot/        # UEFI boot manager (systemd-boot) configurations
│   ├── syslinux/       # BIOS (MBR) bootloader configurations
│   ├── packages.x86_64 # Curated package list for the Slim edition
│   ├── pacman.conf     # Pacman build config with BlackArch repository enabled
│   └── profiledef.sh   # Archiso profile definition and file permissions map
│
├── selective-iso/      # Selective ISO Edition (Custom Security Category Deployments)
│   ├── airootfs/       # Includes category setup scripts (Nessus, OpenVAS, Splunk, SentinelOne, etc.)
│   ├── efiboot/        # UEFI boot configuration
│   ├── syslinux/       # MBR bootloader configuration
│   ├── packages.x86_64 # Selective package list
│   └── profiledef.sh   # Profile metadata and permission settings
│
├── full-iso/           # Full ISO Edition (Complete BlackArch Pentesting Suite)
├── netinstall-iso/     # Network installation minimal bootstrap edition
├── tools/              # ISO compilation scripts, menu generators, and build tools
├── misc/               # Minimal testing configs, disabled tool lists, and package templates
├── build-selective-iso.sh # Helper script for compiling the Selective ISO profile
├── DOCUMENTATION.md    # Developer & architecture reference guide
└── README.md           # Distribution overview & build guide
```

---

## 🔑 Live Environment Credentials

Booting into the live ArcXos ISO provides the following default access accounts:

- **Live User**: `liveuser` (Password: `arcx`)
- **Root Account**: `root` (Password: `arcx`)
- **Sudo Access**: `wheel` group with passwordless password configuration for live user.

---

## 🛠️ How to Build ArcXos ISOs

ArcXos ISOs are compiled using official Arch Linux `archiso` tools.

### 📋 Prerequisites

Build ArcXos from an Arch Linux system or derivative (or Arch-based container/chroot):

```bash
sudo pacman -S --needed archiso git
```

### 🔨 Compilation Commands

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Arunachalam-gojosaturo/ArcXos.git
   cd ArcXos
   ```

2. **Build the Slim Edition**:
   ```bash
   cd slim-iso
   sudo mkarchiso -v -w /var/tmp/archiso-slim-work -o ../out .
   ```

3. **Build the Selective Edition**:
   ```bash
   cd selective-iso
   sudo mkarchiso -v -w /var/tmp/archiso-selective-work -o ../out .
   ```
   *(Or use the automated helper: `./build-selective-iso.sh`)*

4. **Build the Full Edition**:
   ```bash
   cd full-iso
   sudo mkarchiso -v -w /var/tmp/archiso-full-work -o ../out .
   ```

> [!IMPORTANT]
> Always specify `-w /var/tmp/archiso-work` to build on physical disk storage. Avoid using default `/tmp/` because `/tmp` is mounted on `tmpfs` (RAM disk) and will run out of memory during ISO image creation.

5. **Clean Temporary Build Files**:
   ```bash
   sudo rm -rf /var/tmp/archiso-*-work
   ```

The compiled `.iso` image will be saved inside the `out/` folder.

---

## 🎨 Aesthetic & Desktop Customization

ArcXos features custom-crafted cyber security wallpapers located under `airootfs/usr/share/backgrounds/`:

- `background.png` & `blackarch.png` (Default system wallpaper symlinks)
- `Blue_cyber_theme_wallpaper_ARCXOS.jpeg`
- `Cyber_wallpaper_ARCXOS_OS_theme.jpeg`
- `Green_hacker_wallpaper_ARCXOS_OS.jpeg`
- `Woman_with_ARCXOS_text_2K.jpeg`
- `hacktheplanet.png`

Custom wallpaper switcher command:
```bash
arcxos-set-wallpaper
```

---

## 📖 Developer Documentation

For detailed technical specs on adding new packages, configuring `profiledef.sh` permissions, editing `customize_airootfs.sh`, or modifying LightDM themes, see [DOCUMENTATION.md](DOCUMENTATION.md).

---

## 🤝 Contributing

Contributions to ArcXos are welcome!
- **Bug Reports**: Open an issue detailing build logs or hardware compatibility.
- **Theme & Wallpapers**: Submit high-resolution custom artwork or GTK theme enhancements.
- **Tooling & Scripts**: Submit PRs for custom installer improvements or category setup scripts.

---

## 📜 License & Credits

- **License**: Licensed under [GPL-3.0](LICENSE).
- **Upstream Credits**: Built on [Arch Linux](https://archlinux.org) and [BlackArch Linux](https://blackarch.org).
