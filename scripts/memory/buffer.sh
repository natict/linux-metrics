#!/bin/bash

root_dev="$(mount | grep 'on / ' | cut -d' ' -f1)"

dd if=$root_dev of=/dev/null bs=1M count=1024
