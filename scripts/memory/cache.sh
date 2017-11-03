#!/bin/bash

# Read all readable files in /usr (Generates ~1.5GB cache)
# find /usr -readable -type f -exec dd if={} of=/dev/null status=none \;

# Just create a large file
SIZE_IN_MB=4096
dd if=/dev/zero of=/tmp/bigfile bs=1MB count=${SIZE_IN_MB}

echo "Press Enter to continue..."; read
#rm /tmp/bigfile
