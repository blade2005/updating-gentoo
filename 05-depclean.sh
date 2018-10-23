#!/bin/bash
set -e
emerge --ask --depclean
emerge --ask @preserved-rebuild

