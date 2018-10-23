#!/bin/bash
set -e
if [ $(grep -c sys-apps/portage ~/emerge-outdated.log) -gt 0 ]; then
    emerge --ask --oneshot --update sys-apps/portage
else
    echo "Portage is up to date"
fi

