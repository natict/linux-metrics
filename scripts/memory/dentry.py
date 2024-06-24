#!/usr/bin/env python3

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
    input("click any key to terminate")
