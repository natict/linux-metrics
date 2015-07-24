#!/bin/bash

find /usr -readable -type f -exec dd if={} of=/dev/null status=none \;
