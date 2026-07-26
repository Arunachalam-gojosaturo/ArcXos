#!/bin/bash

# exit on error and undefined variables
set -eu

# set locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# enabling all mirrors
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

# repo + database setup
curl -s https://blackarch.org/strap.sh | sh || true
if [ -f /etc/pacman.d/blackarch-mirrorlist ]; then
  sed -i 's|#Server = https://ftp.halifax.rwth-aachen.de|Server = https://ftp.halifax.rwth-aachen.de|g' /etc/pacman.d/blackarch-mirrorlist
  sed -i 's|#Server = https://www.blackarch.org|Server = https://www.blackarch.org|g' /etc/pacman.d/blackarch-mirrorlist
fi

pacman-key --init || true
pacman -Sy --noconfirm blackarch-keyring || true
pacman-key --populate archlinux blackarch || true
pacman -Sy --noconfirm || true

# Install official ArcXos & BlackArch Dark Theme packages inside chroot
pacman -S --noconfirm --needed blackarch-config-xfce blackarch-config-gtk blackarch-config-icons blackarch-config-cursor blackarch-config-bash blackarch-config-zsh blackarch-config-vim arc-gtk-theme flat-remix-gtk flat-remix-icon-theme papirus-icon-theme || true

# Copy ArcXos / BlackArch Theme & Shell Configurations to /etc/skel
if [ -d /usr/share/blackarch/config/xfce ]; then
  mkdir -p /etc/skel/.config/xfce4 /etc/xdg/xfce4
  cp -rf /usr/share/blackarch/config/xfce/. /etc/skel/.config/xfce4/ || true
  cp -rf /usr/share/blackarch/config/xfce/. /etc/xdg/xfce4/ || true
fi
[ -f /usr/share/blackarch/config/bash/bashrc ] && cp /usr/share/blackarch/config/bash/bashrc /etc/skel/.bashrc || true
[ -f /usr/share/blackarch/config/bash/bash_profile ] && cp /usr/share/blackarch/config/bash/bash_profile /etc/skel/.bash_profile || true
[ -f /usr/share/blackarch/config/zsh/zshrc ] && cp /usr/share/blackarch/config/zsh/zshrc /etc/skel/.zshrc || true
[ -d /usr/share/blackarch/config/vim/vim ] && cp -r /usr/share/blackarch/config/vim/vim /etc/skel/.vim || true
[ -f /usr/share/blackarch/config/vim/vimrc ] && cp /usr/share/blackarch/config/vim/vimrc /etc/skel/.vimrc || true

# setup user
id -u liveuser &>/dev/null || useradd -m -g users -G wheel,power,audio,video,storage -s /bin/zsh liveuser || true
echo "liveuser:arcx" | chpasswd
ln -sf /usr/share/backgrounds/arcxoslogo.png /home/liveuser/.face 2>/dev/null || true

mkdir -p /home/liveuser/Desktop
chown -R liveuser:users /home/liveuser/Desktop
chmod -R 755 /home/liveuser/Desktop

if [ -f /usr/share/applications/calamares.desktop ]; then
    ln -sf /usr/share/applications/calamares.desktop /home/liveuser/Desktop/calamares.desktop
    sed -i -e "s|Install System|Install ArcXos|g" /usr/share/applications/calamares.desktop
fi
ln -sf /usr/share/applications/xfce4-terminal-emulator.desktop /home/liveuser/Desktop/terminal.desktop 2>/dev/null || true
ln -sf /usr/share/applications/arcxos-installer.desktop /home/liveuser/Desktop/arcxos-installer.desktop 2>/dev/null || true
[ -f /usr/share/applications/arcxos-gui-installer.desktop ] && ln -sf /usr/share/applications/arcxos-gui-installer.desktop /home/liveuser/Desktop/arcxos-gui-installer.desktop 2>/dev/null || true
[ -f /usr/share/applications/code.desktop ] && ln -sf /usr/share/applications/code.desktop /home/liveuser/Desktop/code.desktop || true
[ -f /usr/share/applications/org.wireshark.Wireshark.desktop ] && ln -sf /usr/share/applications/org.wireshark.Wireshark.desktop /home/liveuser/Desktop/wireshark.desktop || true
[ -f /usr/share/applications/zenmap.desktop ] && ln -sf /usr/share/applications/zenmap.desktop /home/liveuser/Desktop/zenmap.desktop || true
[ -f /usr/share/applications/zaproxy.desktop ] && ln -sf /usr/share/applications/zaproxy.desktop /home/liveuser/Desktop/zaproxy.desktop || true
chmod +x /home/liveuser/Desktop/*.desktop 2>/dev/null || true

# Ensure XFCE desktop config sets ArcXos wallpaper path correctly
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
find /etc/skel/.config/xfce4/ /root/.config/xfce4/ /etc/xdg/xfce4/ -name "xfce4-desktop.xml" 2>/dev/null | while read -r config_file; do
  sed -i 's|/usr/share/backgrounds/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
  sed -i 's|/usr/share/blackarch/wallpaper/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
done

# Populate wallpaper directories
for dest_dir in "/usr/share/blackarch/wallpaper" "/usr/share/backgrounds/xfce" "/usr/share/xfce4/backdrops"; do
  mkdir -p "$dest_dir"
  rm -f "$dest_dir"/* 2>/dev/null || true
  find /usr/share/backgrounds -maxdepth 1 -type f -exec cp -f {} "$dest_dir/" \; 2>/dev/null || true
done

# Symlink ArcXos installer
if [ -f /usr/bin/blackarch-install ] && [ ! -L /usr/bin/blackarch-install ]; then
  mv /usr/bin/blackarch-install /usr/bin/blackarch-install-original
fi
ln -sf /usr/bin/arcxos-installer /usr/bin/blackarch-install

# Configure Wireshark group
if grep -q '^wireshark:' /etc/group; then
  usermod -aG wireshark liveuser || true
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

# Post-Customization Cleanup Phase
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* 2>/dev/null || true
rm -rf /var/lib/pacman/sync/* 2>/dev/null || true
rm -rf /root/.cache/* 2>/dev/null || true
find /var/log -type f -exec truncate -s 0 {} + 2>/dev/null || true
sync
