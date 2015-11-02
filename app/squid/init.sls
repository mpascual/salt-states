squid_pkgs:
  pkg.installed:
    - names:
      - squid
      - httpd-tools

/etc/squid/squid.conf:
  file.managed:
    - source: salt://app/squid/files/squid.conf
    - user: root
    - group: squid
    - mode: 640
    - require:
      - pkg: squid_pkgs

/etc/squid/passwd:
  file.managed:
    - source: salt://app/squid/files/passwd.j2
    - user: squid
    - group: root
    - mode: 655
    - template: jinja
    - defaults:
        user: {{ pillar_data_here }}
        password: {{ pillar_data_here }}

squid-svc:
  service.running:
    - name: squid
    - enable: True
    - require:
      - pkg: squid_pkgs
    - listen:
      - file: /etc/squid/squid.conf
      - file: /etc/squid/passwd

# vim: set ft=yaml ts=2 sw=2 et sts=2:
