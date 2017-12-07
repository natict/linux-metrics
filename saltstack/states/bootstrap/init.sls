update:
  cmd.run:
    - name: 'apt-get  -qq update'
    - order: 1
upgrade:
  module.run:
    - name: pkg.upgrade
    - dist_upgrade: True
    - order: 2

draios_repo:
  pkgrepo.managed:
    - humanname: Draios
    - name: deb http://download.draios.com/stable/deb stable-$(ARCH)/
    - file: /etc/apt/sources.list.d/draios.list
    - keyid: EC51E8C4
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: base_packages

base_packages:
  pkg.installed:
    - pkgs:
      - wget:
      - curl:
      - telnet:
      - strace:
      - git:
      - tree:
      - rsync:
      - less:
      - sysstat:
      - ethtool:
      - screen:
      - bzip2:
      - lsof:
      - sudo:
      - haveged:
      - file:
      - lftp:
      - unzip:
      - htop:
      - heirloom-mailx:
      - htop:
      - python-apt:
      - pkg-config:
      - multitail:
      - vim:
      - ngrep:
      - netcat-openbsd:
      - dnsutils:
      - vim-scripts:
      - iptables-persistent
      - bc
      - aptitude
      - python-msgpack
      - python-m2crypto
      - python-pip
      - lsb-release
      - debconf-utils
      - apt-transport-https:
      - psmisc:
      - atop
      - iotop
      - whois
      - procps
      - sysstat
      - stress
      - linux-tools
      - fio
      - iptraf
      - nethogs
      - iperf
      - nicstat
      - linux-headers-amd64
      - fortunes
      - bash-completion


linux_metrics_workshop:
  git.latest:
    - name: https://github.com/kargig/linux-metrics/
    - rev: master
    - target: /root/linux-metrics
    - remote: origin
    - force_reset: True

netdata:
  cmd.run:
    - name: curl https://my-netdata.io/kickstart-static64.sh >/tmp/kickstart-static64.sh && sh /tmp/kickstart-static64.sh --dont-wait
    - unless: ls -la /opt/netdata/
    - require:
      - pkg: base_packages
  service.running:
    - require:
      - cmd: netdata
    - watch:
      - file: netdata
  file.managed:
    - name: /etc/systemd/system/netdata.service
    - source: salt://bootstrap/netdata.service
    - require:
      - cmd: netdata
rc.local:
  file.managed:
    - name: /etc/rc.local
    - source: salt://bootstrap/rc.local
    - mode: 700

rc-local.service:
  file.managed:
    - name: /etc/systemd/system/rc-local.service
    - source: salt://bootstrap/rc-local.service
  service.running:
    - enable: True
    - watch:
      - file: rc-local.service
    - require:
      - file: rc-local.service

sysstat:
  file.replace:
    - name: /etc/default/sysstat
    - pattern: "^ENABLED=.*"
    - repl: "ENABLED=true"
    - append_if_not_found: True
  service.running:
    - enable: True
    - watch:
      - file: /etc/default/sysstat

locale:
  file.replace:
    - name: /etc/locale.gen
    - pattern: "^# el_GR.UTF-8 UTF-8"
    - repl: "el_GR.UTF-8 UTF-8"
    - append_if_not_found: True
  cmd.wait:
    - name: locale-gen
    - watch:
      - file: /etc/locale.gen

iptables:
  file.managed:
    - name: /etc/iptables/rules.v4
    - source: salt://bootstrap/iptables_redirect
  cmd.wait:
    - name: iptables-restore</etc/iptables/rules.v4
    - watch:
      - file: /etc/iptables/rules.v4
