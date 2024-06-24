#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script as root"
    exit 1
fi

root_dev="$(mount | grep 'on / ' | cut -d' ' -f1)"  # /dev/xvda

# Read 1GB of blocks from the root device
dd if=$root_dev of=/dev/null bs=1M count=4096
