#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "You must run this script as root. Attempting to sudo" 1>&2
    exec sudo -n bash $0 $@
fi

# Wait for cloud-init
sleep 10

# Install packages
DIST="$(lsb_release -cs)"
echo "deb http://repo.netdata.cloud/repos/stable/ubuntu/ ${DIST}/" > /etc/apt/sources.list.d/netdata.list
wget -O - https://repo.netdata.cloud/netdatabot.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/netdata.gpg
apt update
export DEBIAN_PRIORITY=critical
export DEBIAN_FRONTEND=noninteractive
apt install -y sysstat stress procps build-essential linux-tools-generic fio iotop iperf iptraf-ng net-tools \
    nicstat git glibc-doc manpages-dev bpftrace bpfcc-tools netdata \
    ubuntu-dbgsym-keyring

echo "deb http://ddebs.ubuntu.com ${DIST} main restricted universe multiverse
deb http://ddebs.ubuntu.com ${DIST}-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com ${DIST}-proposed main restricted universe multiverse" > /etc/apt/sources.list.d/ddebs.list

apt update
apt install -y bpftrace-dbgsym

# Change netdata systemd definition (e.g. to renice)
mkdir /etc/systemd/system/netdata.service.d/

cat > /etc/systemd/system/netdata.service.d/override.conf<<'EOF'
[Service]
# The minimum netdata Out-Of-Memory (OOM) score.
# netdata (via [global].OOM score in netdata.conf) can only increase the value set here.
# To decrease it, set the minimum here and set the same or a higher value in netdata.conf.
# Valid values: -1000 (never kill netdata) to 1000 (always kill netdata).
OOMScoreAdjust=-1000

# Valid policies: other (the system default) | batch | idle | fifo | rr
# To give netdata the max priority, set CPUSchedulingPolicy=rr and CPUSchedulingPriority=99
CPUSchedulingPolicy=rr

# This sets the scheduling priority (for policies: rr and fifo).
# Priority gets values 1 (lowest) to 99 (highest).
CPUSchedulingPriority=99

Nice=-10
EOF

systemctl daemon-reload
systemctl restart netdata.service

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
