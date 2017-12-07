#!/usr/bin/env python

import os
import time

try:
    t_end = time.time() + 30
    while time.time() < t_end:
        os.makedirs("t")
        os.chdir("t")
except Exception:
    raw_input("press any key to terminate\n")
