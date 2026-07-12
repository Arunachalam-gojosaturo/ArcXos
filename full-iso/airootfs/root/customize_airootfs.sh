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
#sed -i 's|#Server https://ftp.halifax|Server https://ftp.halifax|g' \
#  /etc/pacman.d/mirrorlist

# storing the system journal in RAM
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

# default releng configuration
sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# enable useful services and display manager
enabled_services=('choose-mirror.service' 'lxdm.service' 'pacman-init' 'NetworkManager.service')
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
systemctl disable dhcpcd sshd rpcbind.service

# remove special (not needed) files
sed -i 's/--autologin root/--autologin arcx/g' /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /root/{.automated_script.sh,.zlogin}

# setting root password
echo "root:arcx" | chpasswd

# create default live user arcx
useradd -m -g users -G wheel,audio,video,power,storage,optical,network -s /bin/bash arcx
echo "arcx:arcx" | chpasswd
mkdir -p /etc/sudoers.d
echo "arcx ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/arcx

# copy files over to home
cp -r /etc/skel/. /root/.
cp -r /etc/skel/. /home/arcx/.
chown -R arcx:users /home/arcx

# setup repository, add pacman.conf entry, sync databases
pacman-key --init || true
pacman-key --populate archlinux || true
if curl -s https://blackarch.org/strap.sh > /tmp/strap.sh; then
  sh /tmp/strap.sh || true
else
  if [ -f /usr/share/doc/blackarch-keyring/keyring.gpg ] || [ -f /usr/share/pacman/keyrings/blackarch.gpg ]; then
    pacman-key --populate blackarch || true
  fi
  if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
    cat << 'EOF' >> /etc/pacman.conf

[blackarch]
SigLevel = Optional TrustAll
Server = https://www.blackarch.org/blackarch/$repo/os/$arch
EOF
  fi
fi
pacman -Syy --noconfirm || true
pacman -Fyy || true
pacman-db-upgrade || true
updatedb || true
sync

# font configuration
ln -sf /etc/fonts/conf.avail/* /etc/fonts/conf.d
rm -f /etc/fonts/conf.d/05-reset-dirs-sample.conf
rm -f /etc/fonts/conf.d/09-autohint-if-no-hinting.conf

# default shell
chsh -s /bin/bash

# Check if internet is available inside chroot
has_internet=0
if curl -s --connect-timeout 3 https://rubygems.org >/dev/null; then
  has_internet=1
fi

# download and install exploits, but remove bin-sploits from exploit-db
if command -v sploitctl >/dev/null 2>&1 && [ "$has_internet" -eq 1 ]; then
  sploitctl -f 1 -t 5 -r 2 -XR || true
  sploitctl -f 2 -t 5 -r 2 -XR || true
  sploitctl -f 3 -t 5 -r 2 -XR || true
  rm -rf /usr/share/exploits/exploit-db/exploitdb-bin-sploits || true
fi

# temporary fixes for ruby based tools
fix_ruby_tool() {
  local tool_dir="$1"
  local bundle_cmd="${2:-bundle}"
  local bundle_args="${3:-}"
  if [ "$has_internet" -eq 0 ]; then
    echo "No internet connection inside chroot, skipping bundle install for $tool_dir"
    return 0
  fi
  if [ -d "$tool_dir" ]; then
    (
      cd "$tool_dir"
      rm -f Gemfile.lock
      $bundle_cmd config set build.nokogiri --use-system-libraries || true
      $bundle_cmd config set path 'vendor/bundle' || true
      if [ -n "$bundle_args" ]; then
        $bundle_cmd install $bundle_args || true
      else
        $bundle_cmd install || true
      fi
      rm -f Gemfile.lock
    )
  fi
}

fix_ruby_tool "/usr/share/arachni/" "bundle-2.3"
fix_ruby_tool "/usr/share/smbexec/"
fix_ruby_tool "/usr/share/beef/"
fix_ruby_tool "/usr/share/catphish/"
fix_ruby_tool "/usr/share/wpbrute-rpc/" "bundle" "--without test development"
fix_ruby_tool "/usr/share/staekka/" "bundle" "--no-cache --deployment"
fix_ruby_tool "/usr/share/vane/" "bundle" "--without test development"
fix_ruby_tool "/usr/share/vcsmap/" "bundle" "--without test development"
fix_ruby_tool "/usr/share/vsaudit/"
fix_ruby_tool "/usr/share/whitewidow/"
fix_ruby_tool "/usr/share/sitediff/"
fix_ruby_tool "/usr/share/wordpress-exploit-framework/"
fix_ruby_tool "/usr/share/kautilya/"
fix_ruby_tool "/usr/share/whatweb/"

# remove not needed .desktop entries
rm -f /usr/share/xsessions/blackarch-dwm.desktop
rm -f /usr/share/xsessions/openbox-kde.desktop
rm -f /usr/share/xsessions/i3-with-shmlog.desktop
rm -f /usr/share/xsessions/xfce.desktop
rm -f /usr/share/xsessions/*gnome*.desktop
rm -f /usr/share/xsessions/*kde*.desktop
rm -f /root/install.txt

# add INSTALL file
echo "Type arcxos-install and follow the instructions." > /root/INSTALL
echo "Type arcxos-install and follow the instructions." > /home/arcx/INSTALL
chown arcx:users /home/arcx/INSTALL
if [ -f /usr/bin/blackarch-install ]; then
  ln -sf /usr/bin/blackarch-install /usr/bin/arcxos-install
fi

# GDK Pixbuf
gdk-pixbuf-query-loaders --update-cache

# tmp fix for awesome exit()
if [ -f /usr/share/awesome/lib/awful/menu.lua ]; then
  sed -i 's|local visible, action = cmd(item, self)|local visible, action = cmd(0, self)|' /usr/share/awesome/lib/awful/menu.lua
fi

# lxdm
rm -rf /etc/lxdm
if [ -d /etc/lxdm-blackarch ]; then
  mv /etc/lxdm-blackarch /etc/lxdm
fi
if [ -f /etc/lxdm/lxdm.conf ]; then
  sed -i 's/^#\s*autologin=.*/autologin=arcx/' /etc/lxdm/lxdm.conf
  sed -i 's/^autologin=.*/autologin=arcx/' /etc/lxdm/lxdm.conf
  sed -i 's/^session=.*/session=\/usr\/bin\/awesome/' /etc/lxdm/lxdm.conf
fi

# fluxbox
rm -rf /usr/share/fluxbox
if [ -d /root/.fluxbox ]; then
  cp -r /root/.fluxbox /usr/share/fluxbox
fi

# /etc
echo 'ArcXOS' > /etc/arch-release

# vim
if [ -d /usr/share/blackarch/config/vim/vim ]; then
  cp -r /usr/share/blackarch/config/vim/vim /root/.vim
  cp -r /usr/share/blackarch/config/vim/vim /home/arcx/.vim
  chown -R arcx:users /home/arcx/.vim
fi
if [ -f /usr/share/blackarch/config/vim/vimrc ]; then
  cp /usr/share/blackarch/config/vim/vimrc /root/.vimrc
  cp /usr/share/blackarch/config/vim/vimrc /home/arcx/.vimrc
  chown arcx:users /home/arcx/.vimrc
fi

