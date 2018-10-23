#!/bin/bash
set -e
# Clean up distfiles
eclean distfiles

# Read news
eselect news read

# Update files in /etc
etc-update

