{%- set password=grains['uuid'][:10] %}
sudo:
  pkg.installed

workshop:
  user.present:
    - home: /home/workshop
    - password: {{password}}
    - hash_password: True
    - shell: /bin/bash
    - fullname: workshop user
    - require:
      - pkg: sudo 
workshop_bashrc:
  file.managed:
    - name: /home/workshop/.bashrc
    - user: workshop
    - group: workshop
    - source: salt://users/root_bashrc
    - require:
      - user: workshop

/etc/sudoers.d/workshop:
  file.managed:
    - source: salt://users/workshop_sudoers
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - check_cmd: /usr/sbin/visudo -c -f
    - require:
      - pkg: sudo
      - user: workshop

root_bashrc:
  file.managed:
    - name: /root/.bashrc
    - source: salt://users/root_bashrc


linux_metrics_workshop_2:
  git.latest:
    - name: https://github.com/kargig/linux-metrics/
    - rev: master
    - target: /home/workshop/linux-metrics
    - remote: origin
    - user: workshop
    - force_reset: True
    - require:
      - user: workshop
