#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "You must run this script as root. Attempting to sudo" 1>&2
    exec sudo -n bash $0 $@
fi

# Wait for cloud-init
sleep 10

# Install packages
apt-get update

apt-get -y install procps sysstat stress python2.7 gcc vim linux-tools-common linux-tools-generic linux-tools-$(uname -r) fio iotop iperf iptraf nethogs nicstat git

# Disable transparent huge pages
cat > /etc/rc.local <<'EOF'
#!/bin/sh -e
#
# rc.local
#

THP_DIR="/sys/kernel/mm/transparent_hugepage"

if test -f $THP_DIR/enabled; then
    echo never > $THP_DIR/enabled
fi

if test -f $THP_DIR/defrag; then
    echo never > $THP_DIR/defrag
fi

exit 0
EOF

# Clone linux-metrics in the user's home
cat > /etc/profile.d/clone-linux-metrics.sh <<'EOF'
#!/bin/bash
if [ ! -e ~/linux-metrics ]; then
    echo "unable to find linux-metrics directory- cloning..."
    pushd ~
    git clone https://github.com/natict/linux-metrics.git
    popd
fi
EOF
