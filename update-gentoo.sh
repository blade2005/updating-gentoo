#!/bin/bash
set -e
./01-sync-portage.sh && \
./02-update-portage.sh && \
./03-update-gcc.sh && \
./04-update-world.sh && \
./05-depclean.sh && \
./06-misc.sh

