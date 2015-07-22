#!/bin/bash

while true; do dd if=/dev/zero of=/tmp/test.1G bs=1M count=1024; done
