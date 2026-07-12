# <p align="center"><img src="slim-iso/airootfs/usr/share/backgrounds/arcxoslogo.png" alt="ArcXos Logo" width="200"/><br>ArcXos Linux</p>

🛡️ **ArcXos** is a highly customized, high-performance, and lightweight security auditing, ethical hacking, and penetration testing Linux distribution built on top of Arch Linux and BlackArch. 

Designed for both security professionals and enthusiasts, ArcXos delivers a fast, stable, and sleek desktop experience with custom aesthetics, robust tool configurations, and streamlined installation profiles.

---

## ✨ Features

- **🚀 Multiple Desktop Layouts**: Configured with responsive and lightweight environments including XFCE4, Awesome WM, and Openbox.
- **🎨 Sleek Dark Aesthetics**: Custom themes, icon sets, wallpapers, and a custom LightDM greeter setup for a polished, modern look.
- **🛠️ Professional Tooling**: Out-of-the-box support for the complete suite of BlackArch tools, optimized and categorized.
- **⚙️ Optimized Build Systems**: Configured with modular Archiso profiles for building custom ISOs easily.
- **📦 Dual Distribution Profiles**:
  - **Slim Edition (`slim-iso`)**: Lightweight footprint featuring XFCE4 and essential pentesting suites.
  - **Full Edition (`full-iso`)**: The complete security suite installing all standard security auditing tools.

---

## 📂 Repository Structure

The repository contains the build configurations (Archiso profiles) for building the ArcXos ISOs:

```
ArcXos/
├── slim-iso/           # Configuration files for the Slim ISO edition (XFCE4 + LightDM)
│   ├── airootfs/       # Files overlayed directly onto the live filesystem (/etc, /root, /usr, etc.)
│   ├── efiboot/        # UEFI systemd-boot configurations
│   ├── syslinux/       # MBR boot configurations
│   ├── packages.x86_64 # Curated package list for the Slim edition
│   ├── pacman.conf     # Pacman configuration for the build process
│   └── profiledef.sh   # Main build profile definition and permissions
│
├── full-iso/           # Configuration files for the Full ISO edition (Full BlackArch suite)
│   ├── airootfs/
│   ├── efiboot/
│   ├── syslinux/
│   ├── packages.x86_64 # Extensive package list installing all tools
│   ├── pacman.conf
│   └── profiledef.sh
│
├── netinstall-iso/     # Network install profile (minimum bootstrap size)
├── tools/              # Dev tools and scripts for building/managing the distribution
├── misc/               # Additional configurations and files used during development
├── DOCUMENTATION.md    # Detailed developer and configuration documentation
└── README.md           # Main overview (this file)
```

---

## 🛠️ How to Build ArcXos ISOs

ArcXos is built using the official `archiso` tools. Follow the guide below to build your own custom ArcXos ISO.

### 📋 Prerequisites

You must be running an Arch Linux system or a derivative. Install the build dependencies:

```bash
sudo pacman -S archiso git
```

### 🔨 Build Steps

1. **Clone the Repository** (if not already done):
   ```bash
   git clone https://github.com/Arunachalam-gojosaturo/ArcXos.git
   cd ArcXos
   ```

2. **Select your edition**:
   - For **Slim Edition**:
     ```bash
     cd slim-iso
     ```
   - For **Full Edition**:
     ```bash
     cd full-iso
     ```

3. **Compile the ISO**:
   Run the `mkarchiso` build tool with root permissions. By default, it requires a work directory and an output directory:
   ```bash
   sudo mkarchiso -v -w /tmp/archiso-work -o ../out .
   ```

4. **Verify & Clean up**:
   Once completed, the build process will generate the ISO file in the `../out/` directory. You can clean up the temporary build environment files with:
   ```bash
   sudo rm -rf /tmp/archiso-work
   ```

---

## ⚙️ Key Customizations in ArcXos

### Live User Credentials
The live environment is configured with the following credentials:
- **Default User**: `liveuser` (Password: `arcx`)
- **Root User**: `root` (Password: `arcx`)

### Custom Scripts & Startup
- **[customize_airootfs.sh](file:///home/arunachalam/blackarch-iso/slim-iso/airootfs/root/customize_airootfs.sh)**: Sets up localization, timezone, user additions, fonts, default shell, BlackArch strap script configuration, and desktop environment settings.
- **[profiledef.sh](file:///home/arunachalam/blackarch-iso/slim-iso/profiledef.sh)**: Defines custom permissions for filesystem overlays, ISO labels, and supported boot modes (BIOS + UEFI).
- **Backgrounds**: Located under `airootfs/usr/share/backgrounds/` containing a collection of high-resolution cyber security and minimalist wallpapers.

---

## 🤝 Contributing

We welcome contributions to package lists, aesthetic improvements, desktop themes, and documentation. Feel free to open an issue or submit a pull request!

## 📜 License

This project is licensed under the GPL-3.0 License - see the upstream Archiso/BlackArch licenses for more details.
