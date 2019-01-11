#!/bin/bash
set -e
if [ $(grep -c 'sys-devel/gcc ' ~/emerge-outdated.log) -gt 0 ];then
    emerge --ask --update sys-devel/gcc
    gcc-config -l
    read -p "Which gcc should we switch to?" new_gcc
    gcc-config $new_gcc
    env-update && source /etc/profile
    emerge --oneshot sys-devel/libtool && emerge @preserved-rebuild && gcc --version && equery l sys-devel/gcc && old_gcc=$(equery l sys-devel/gcc | grep gcc | head -n1) && echo $old_gcc
    emerge --ask --depclean =${old_gcc} # replace with the version you want to remove
    emerge @preserved-rebuild
else
    echo "GCC is up to date"
fi

