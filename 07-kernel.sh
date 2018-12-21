#!/bin/bash -e

option=$(eselect kernel list | tail -n1 | awk '{print $1}' |cut -d\[ -f2 | cut -d\] -f1)
mdadm_args=""
if [ -e /etc/mdadm.conf ];then
    mdadm_args="--mdadm --mdadm-config=/etc/mdadm.conf"
fi

eselect kernel set $option && \
eselect kernel list && \
cd /usr/src/linux && \
zcat /proc/config.gz > .config && \
make oldconfig && \
make -j4 && \
make modules_install && \
make install && \
genkernel \
    --compress-initramfs \
    --compress-initramfs-type=lzop \
    --symlink \
    --lvm \
    ${mdadm_args} \
    initramfs && \
grub-mkconfig -o /boot/grub/grub.cfg
