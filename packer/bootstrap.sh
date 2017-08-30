#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "You must run this script as root. Attempting to sudo" 1>&2
    exec sudo -n bash $0 $@
fi

# Wait for cloud-init
sleep 10

# sysdig repo
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
curl -s -o /etc/apt/sources.list.d/draios.list http://download.draios.com/stable/deb/draios.list

# Install packages
apt-get update
export DEBIAN_PRIORITY=critical
export DEBIAN_FRONTEND=noninteractive

apt-get -y install procps sysstat stress python2.7 gcc vim vim-youcompleteme linux-tools-common linux-tools-generic linux-tools-$(uname -r) fio iotop iperf iptraf nethogs nicstat git build-essential manpages-dev glibc-doc
apt-get -y install linux-headers-$(uname -r) sysdig

# BCC
apt-get install -y bison build-essential cmake flex git libedit-dev \
  libllvm3.7 llvm-3.7-dev libclang-3.7-dev python zlib1g-dev libelf-dev luajit luajit-5.1-dev

cd ~
git clone https://github.com/iovisor/bcc.git
mkdir bcc/build; cd bcc/build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
make install


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
if [[ ! -e ~/linux-metrics ]] && [[ $(id -u) -ne 0 ]]; then
    echo "unable to find linux-metrics directory- cloning..."
    pushd ~
    git clone https://github.com/natict/linux-metrics.git
    popd
fi
EOF
