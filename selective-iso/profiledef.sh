#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="arcxos-selective"
iso_label="ARCXOS_SEL_$(date +%Y%m)"
iso_publisher="ArcXos <https://www.blackarch.org/>"
iso_application="ArcXos Selective Optimized ISO"
iso_version="$(date +%Y.%m.%d)"
install_dir="arcxos"
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"

# High-Speed ZSTD SquashFS Compression for ultra-fast boot times
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-b' '1M')

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
  ["/usr/bin/arcxos-hyper-dl"]="0:0:0755"
  ["/usr/bin/arcxos-dl"]="0:0:0755"
  ["/usr/bin/demo.sh"]="0:0:0755"
  ["/usr/bin/falcon-sensor-setup"]="0:0:0755"
  ["/usr/bin/sentinelone-setup"]="0:0:0755"
  ["/usr/bin/splunk-setup"]="0:0:0755"
  ["/usr/bin/nessus-setup"]="0:0:0755"
  ["/usr/bin/security-onion-setup"]="0:0:0755"
  ["/usr/bin/okta-setup"]="0:0:0755"
  ["/usr/bin/kali-tools-setup"]="0:0:0755"
  ["/usr/bin/openvas-setup"]="0:0:0755"
  ["/usr/bin/snort-setup"]="0:0:0755"
  ["/usr/bin/snyk-setup"]="0:0:0755"
  ["/usr/bin/cuckoo-setup"]="0:0:0755"
)
