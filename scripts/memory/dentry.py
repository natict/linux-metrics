#!/usr/bin/env python

import os
import uuid
import sys

try:
    directory = sys.argv[1]
except IndexError:
    directory = "./trash"

if not os.path.exists(directory):
    os.makedirs(directory)

try:
    while True:
        open(os.path.join(directory, str(uuid.uuid4())), 'w')
except Exception:
    raw_input("click any key to terminate")
