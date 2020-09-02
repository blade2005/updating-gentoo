#!/bin/bash
set -e
echo "America/Chicago" > /etc/timezone; emerge --config sys-libs/timezone-data
grep -q 'en_US.UTF-8' /etc/locale.gen  || \
cat << EOF >> /etc/locale.gen
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF

locale-gen;
eselect locale list
eselect locale set $(read -p 'Select your locale number: ')

env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

mkdir -p /etc/portage/package.{accept_keywords,use,mask,unmask}

echo 'sys-kernel/vanilla-sources ~amd64' >> /etc/portage/package.accept_keywords/kernel

emerge gentoolkit

test -d /etc/portage/sets || mkdir /etc/portage/sets

cat << 'EOF' /etc/portage/sets/blade-recommended
app-admin/eclean-kernel
app-admin/logrotate
app-admin/perl-cleaner
app-admin/sudo
app-admin/superadduser
app-admin/sysklogd
app-admin/sysstat
app-arch/libarchive
app-arch/lzop
app-arch/unrar
app-arch/zip
app-editors/nano
app-editors/vim
app-emulation/docker
app-emulation/docker-compose
app-emulation/libvirt
app-emulation/qemu
app-misc/jq
app-misc/screen
app-office/sc
app-portage/eix
app-portage/genlop
app-portage/gentoolkit
app-portage/layman
app-portage/portage-utils
app-portage/smart-live-rebuild
app-text/tree
app-vim/gentoo-syntax
dev-python/pip
dev-util/ctags
dev-util/strace
dev-vcs/cvs
dev-vcs/git
dev-vcs/mercurial
dev-vcs/subversion
games-misc/fortune-mod
net-analyzer/iftop
net-analyzer/mtr
net-analyzer/rrdtool
net-analyzer/tcpdump
net-analyzer/tcptraceroute
net-analyzer/traceroute
net-dns/bind-tools
net-misc/curl
net-misc/netifrc
net-misc/ntp
net-misc/openssh
net-misc/rclone
net-misc/whois
net-vpn/strongswan
sys-apps/dmidecode
sys-apps/hdparm
sys-apps/hwinfo
sys-apps/lm-sensors
sys-apps/lshw
sys-apps/man-db
sys-apps/mlocate
sys-apps/pciutils
sys-block/parted
sys-boot/grub:2
sys-devel/distcc
sys-fs/lvm2
sys-fs/mdadm
sys-kernel/linux-firmware
sys-kernel/linux-headers
sys-power/acpi
sys-power/acpid
sys-power/cpupower
sys-power/iasl
sys-power/thermald
sys-process/at
sys-process/cronbase
sys-process/cronie
sys-process/htop
sys-process/iotop
sys-process/lsof
sys-process/numactl
www-client/links
www-client/lynx
sys-kernel/vanilla-sources
media-gfx/imagemagick
media-video/mpv
app-editors/neovim
sys-kernel/genkernel
EOF

emerge @blade-recommended
for i in sshd acpid atd docker hdpart hwclock libvirtd libvirtd-guests lvm mdadm net.en01 ntp-client sensord sysstat sysklogd cronie virtlogd;do
    test -e /etc/init.d/$i && rc-update add $i;
done
