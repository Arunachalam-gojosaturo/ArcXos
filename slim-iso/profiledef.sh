#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="arcxos-slim"
iso_label="ARCXOS_$(date +%Y%m)"
iso_publisher="ArcXos <https://www.blackarch.org/>"
iso_application="ArcXos Slim ISO"
iso_version="$(date +%Y.%m.%d)"
install_dir="arcxos"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
