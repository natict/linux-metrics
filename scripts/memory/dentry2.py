#!/usr/bin/env python3

import os

try:
    while True:
        os.makedirs("t")
        os.chdir("t")
except Exception:
    input("press any key to terminate\n")
