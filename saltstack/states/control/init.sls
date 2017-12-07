salt:
  pkg.latest:
    - pkgs:
      - python2.7
      - python-apt
      - python-msgpack
      - python-m2crypto
      - python-pip
      - apt-transport-https
      - pkg-config
      - python-pip
salt-ssh:
  pip.installed:
    - require:
      - pkg: salt
  
