#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="arcxos-slim"
iso_label="ARCXOS_$(date +%Y%m)"
iso_publisher="ArcXos <https://www.blackarch.org/>"
iso_application="ArcXos Slim ISO"
iso_version="$(date +%Y.%m.%d)"
install_dir="arcxos"
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"

# High-efficiency SquashFS XZ Compression settings to reduce ISO size
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')

file_permissions=(
  ["/etc/shadow"]="0:0:0400"
  ["/etc/gshadow"]="0:0:0400"
  ["/etc/sudoers.d"]="0:0:0750"
  ["/etc/sudoers.d/wheel"]="0:0:0440"
  ["/etc/polkit-1/rules.d"]="102:102:0750"
  ["/etc/polkit-1/rules.d/49-nopasswd_global.rules"]="102:102:0640"
  ["/root"]="0:0:0700"
  ["/root/customize_airootfs.sh"]="0:0:0755"
  ["/usr/bin/arcxos-installer"]="0:0:0755"
  ["/usr/bin/arcxos-gui-installer"]="0:0:0755"
  ["/usr/bin/arcxos-set-wallpaper"]="0:0:0755"
)

