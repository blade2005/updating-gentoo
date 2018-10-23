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

