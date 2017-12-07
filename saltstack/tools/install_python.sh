#!/bin/bash
DOMAIN='example.com'
 for i in  1 2 ; do ssh ws${i}.${DOMAIN} 'DEBIAN_FRONTEND=noninteractive;apt-get -y -qq install python2.7>/dev/null' ; done
