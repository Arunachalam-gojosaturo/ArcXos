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
systemctl disable dhcpcd sshd rpcbind.service systemd-networkd.service systemd-networkd-wait-online.service systemd-resolved.service iwd.service

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
mkdir -p /home/liveuser/Desktop
chown -R liveuser:users /home/liveuser/Desktop
chmod -R 755 /home/liveuser/Desktop
if [ -f /usr/share/applications/calamares.desktop ]; then
    ln -sf /usr/share/applications/calamares.desktop /home/liveuser/Desktop/calamares.desktop
    sed -i -e "s|Install System|Install ArcXos|g" /usr/share/applications/calamares.desktop
fi
ln -sf /usr/share/applications/xfce4-terminal-emulator.desktop /home/liveuser/Desktop/terminal.desktop
chmod +x /home/liveuser/Desktop/*.desktop

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
find /etc/skel/.config/xfce4/ /root/.config/xfce4/ -name "xfce4-desktop.xml" 2>/dev/null | while read -r config_file; do
  sed -i 's|/usr/share/backgrounds/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
  sed -i 's|/usr/share/blackarch/wallpaper/[^"]*|/usr/share/backgrounds/background.png|g' "$config_file"
done

# Override any wallpaper in blackarch wallpaper folder if it gets installed
if [ -d /usr/share/blackarch/wallpaper ]; then
  find /usr/share/blackarch/wallpaper/ -type f -name "*.png" -o -name "*.jpg" | while read -r wp; do
    cp /usr/share/backgrounds/background.png "$wp"
  done
fi

# Override default XFCE wallpapers to ensure they display our custom background
if [ -d /usr/share/backgrounds/xfce ]; then
  find /usr/share/backgrounds/xfce/ -type f | while read -r wp; do
    cp /usr/share/backgrounds/background.png "$wp"
  done
fi
if [ -d /usr/share/xfce4/backdrops ]; then
  find /usr/share/xfce4/backdrops/ -type f | while read -r wp; do
    cp /usr/share/backgrounds/background.png "$wp"
  done
fi

