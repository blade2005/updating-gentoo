#!/bin/bash
set -e
emerge --columns --ask --backtrack=100 --update --changed-use --deep --newuse --with-bdeps=y --autounmask-backtrack=y --verbose-conflicts @world
emerge --ask @preserved-rebuild

