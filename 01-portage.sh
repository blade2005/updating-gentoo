#!/bin/bash
set -e
update_timestamp=$(date -d "$(cat /usr/portage/metadata/timestamp.chk)"  '+%s')
yesterday_ts=$(date -d yesterday '+%s')
if [ "$update_timestamp" -lt "$yesterday_ts" ]; then
    emerge --sync
    type -p layman >/dev/null 2>&1 && layman -S
else
    echo "Portage repo is up to date"
fi

# Show outdated packages
if [[ ( /usr/portage/metadata/timestamp.chk -nt ~/emerge-outdated.log ) || ( ! -e  ~/emerge-outdated.log ) ]]; then
    emerge --columns --pretend  --backtrack=100  --update --changed-use --deep --newuse --with-bdeps=y --autounmask-backtrack=y @world 2>&1 | tee ~/emerge-outdated.log
fi

if [ $(grep -c sys-apps/portage ~/emerge-outdated.log) -gt 0 ]; then
    emerge --ask --oneshot --update sys-apps/portage
else
    echo "Portage is up to date"
fi

if [ $(grep -c sys-devel/gcc ~/emerge-outdated.log) -gt 0 ];then
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

# non special - upgrade everything
emerge --columns --ask --backtrack=100 --update --changed-use --deep --newuse --with-bdeps=y --autounmask-backtrack=y @world
emerge --ask @preserved-rebuild

emerge --ask --depclean
emerge --ask @preserved-rebuild

# Clean up distfiles
eclean distfiles

# Read news
eselect news read

# Update files in /etc
etc-update
