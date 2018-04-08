This is what I needed in order to support my wwan interface (Sierra Wireless EM7455)
on my Yoga 370

* wwan.sh: script to bring up or down th einterface e.g. wwan.sh up or wwan.sh down
* wwan_parse_ip_info: perl script to parse output of mbimcli --query-ip-configuration and generate shell commands to configure wwan device

Installation
------------

sudo install -o root -g root wwan.sh /etc/network/wwan.sh
sudo install -o root -g root wwan_parse_ip_info /etc/network/wwan_parse_ip_info

In /etc/network/interfaces

 iface wwan0 inet manual
  pre-up /etc/network/wwan.sh start
  pre-down /etc/network/wwan.sh stop

