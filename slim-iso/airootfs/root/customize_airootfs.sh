#!/bin/bash

# exit on error and undefined variables
set -eu

# set locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# enabling all mirrors
#sed -i "s|#Server|Server|g" /etc/pacman.d/mirrorlist
sed -i 's|#Server https://ftp.halifax|Server https://ftp.halifax|g' \
  /etc/pacman.d/mirrorlist

# storing the system journal in RAM
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

# default releng configuration
sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# enable useful services and display manager
enabled_services=('choose-mirror.service' 'lightdm.service' 'pacman-init'
  'NetworkManager' 'irqbalance' 'vboxservice')
systemctl enable ${enabled_services[@]}
systemctl set-default graphical.target

# create the user directory for live session
if [ ! -d /root ]; then
  mkdir /root
  chmod 700 /root && chown -R root:root /root
fi

# disable pc speaker beep
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# disable network stuff
rm -f /etc/udev/rules.d/81-dhcpcd.rules
systemctl disable dhcpcd sshd rpcbind.service systemd-networkd.service systemd-networkd-wait-online.service NetworkManager-wait-online.service systemd-resolved.service iwd.service

# remove special (not needed) files
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /root/{.automated_script.sh,.zlogin}

# setting root password
echo "root:arcx" | chpasswd

# copy config files to skel
cp /usr/share/blackarch/config/bash/bashrc /etc/skel/.bashrc
cp /usr/share/blackarch/config/bash/bash_profile /etc/skel/.bash_profile
cp /usr/share/blackarch/config/zsh/zshrc /etc/skel/.zshrc

# setup user
useradd -m -g users -G wheel,power,audio,video,storage -s /bin/zsh liveuser
echo "liveuser:arcx" | chpasswd
ln -sf /usr/share/backgrounds/arcxoslogo.png /home/liveuser/.face
mkdir -p /etc/skel/Desktop /home/liveuser/Desktop
chown -R liveuser:users /home/liveuser/Desktop
chmod -R 755 /home/liveuser/Desktop
ln -sf /usr/share/applications/arcxos-gui-installer.desktop /etc/skel/Desktop/arcxos-gui-installer.desktop
ln -sf /usr/share/applications/arcxos-cli-installer.desktop /etc/skel/Desktop/arcxos-cli-installer.desktop
ln -sf /usr/share/applications/arcxos-gui-installer.desktop /home/liveuser/Desktop/arcxos-gui-installer.desktop
ln -sf /usr/share/applications/arcxos-cli-installer.desktop /home/liveuser/Desktop/arcxos-cli-installer.desktop
ln -sf /usr/share/applications/xfce4-terminal-emulator.desktop /home/liveuser/Desktop/terminal.desktop
chmod +x /etc/skel/Desktop/*.desktop /home/liveuser/Desktop/*.desktop 2>/dev/null || true


# copy files over to home
cp -r /etc/skel/. /root/.

# repo + database
curl -s https://blackarch.org/strap.sh | sh
# Ensure we have working mirrors enabled in blackarch-mirrorlist
sed -i 's|#Server = https://ftp.halifax.rwth-aachen.de|Server = https://ftp.halifax.rwth-aachen.de|g' /etc/pacman.d/blackarch-mirrorlist
sed -i 's|#Server = https://www.blackarch.org|Server = https://www.blackarch.org|g' /etc/pacman.d/blackarch-mirrorlist
pacman -Syy --noconfirm
pacman-key --init
pacman-key --populate blackarch archlinux
pacman -Fyy
pacman-db-upgrade
updatedb
sync

# font configuration
ln -sf /etc/fonts/conf.avail/* /etc/fonts/conf.d
rm -f /etc/fonts/conf.d/05-reset-dirs-sample.conf
rm -f /etc/fonts/conf.d/09-autohint-if-no-hinting.conf

# temporary fixes for ruby based tools
cd /usr/share/whatweb && rm -f Gemfile.lock &&
  bundle config set build.nokogiri --use-system-libraries &&
  bundle config set path 'vendor/bundle' &&
  bundle install && rm -f Gemfile.lock

# change default jdk
default_java=$(archlinux-java status | grep -o 'java-[a-zA-Z0-9/-]\+' | head -n 1)
if [ -n "$default_java" ]; then
  archlinux-java set "$default_java"
fi

# Temporary fix for calamares
#pacman -U --noconfirm https://archive.archlinux.org/packages/d/dosfstools/dosfstools-4.1-3-x86_64.pkg.tar.xz

# GDK Pixbuf
gdk-pixbuf-query-loaders --update-cache

# /etc
echo 'ArcXos' > /etc/arch-release

# vim
cp -r /usr/share/blackarch/config/vim/vim /home/liveuser/.vim
cp /usr/share/blackarch/config/vim/vimrc /home/liveuser/.vimrc

# Ensure XFCE desktop config sets wallpaper path correctly
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
find /etc/skel/.config/xfce4/ /root/.config/xfce4/ /etc/xdg/xfce4/ -name "xfce4-desktop.xml" 2>/dev/null | while read -r config_file; do
  sed -i 's|/usr/share/backgrounds/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
  sed -i 's|/usr/share/blackarch/wallpaper/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
done

# Populate all wallpaper directories with all of our custom wallpapers from /usr/share/backgrounds
# This ensures they are selectable, while clearing out old/unused wallpapers first
for dest_dir in "/usr/share/blackarch/wallpaper" "/usr/share/backgrounds/xfce" "/usr/share/xfce4/backdrops"; do
  # Create the directory if it does not exist, ensuring wallpapers are placed where XFCE expects them
  mkdir -p "$dest_dir"
  # Clear existing files first to avoid duplicates or orphaned default files
  rm -f "$dest_dir"/* 2>/dev/null || true
  # Copy only files from /usr/share/backgrounds into the folder
  find /usr/share/backgrounds -maxdepth 1 -type f -exec cp -f {} "$dest_dir/" \; 2>/dev/null || true
done

# Rename existing BlackArch installer if it exists
if [ -f /usr/bin/blackarch-install ] && [ ! -L /usr/bin/blackarch-install ]; then
  mv /usr/bin/blackarch-install /usr/bin/blackarch-install-original
fi
# Symlink blackarch-install to arcxos-installer
ln -sf /usr/bin/arcxos-installer /usr/bin/blackarch-install

# Add liveuser to wireshark group and configure dumpcap for passwordless packet capture
if grep -q '^wireshark:' /etc/group; then
  usermod -aG wireshark liveuser
  if [ -f /usr/bin/dumpcap ]; then
    chgrp wireshark /usr/bin/dumpcap
    chmod 4755 /usr/bin/dumpcap
  fi
fi

# Copy finalized etc/skel to liveuser and root homes, and set permissions
cp -rf /etc/skel/. /home/liveuser/
cp -rf /etc/skel/. /root/
chown -R liveuser:users /home/liveuser
chown -R root:root /root

# ==========================================
# Post-Customization Cleanup Phase (Sizesaving)
# ==========================================
# 1. Clear pacman download cache completely
pacman -Scc --noconfirm
rm -rf /var/cache/pacman/pkg/*

# 2. Clear package synchronization databases (requires pacman -Sy on live run to update)
rm -rf /var/lib/pacman/sync/*

# 3. Clear root build cache and temporary logs
rm -rf /root/.cache/*
find /var/log -type f -exec truncate -s 0 {} +

# 4. Final file system synchronization
sync


