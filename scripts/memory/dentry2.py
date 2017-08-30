#!/usr/bin/env python

import os

try:
    while True:
        os.makedirs("t")
        os.chdir("t")
except Exception:
    raw_input("press any key to terminate\n")
