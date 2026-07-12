#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="ArcXOS"
iso_label="ARCXOS_$(date +%Y%m)"
iso_publisher="ArcXOS <https://arcxos.org/>"
iso_application="ArcXOS Live/Install Medium"
iso_version="$(date +%Y.%m)"
install_dir="blackarch"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
