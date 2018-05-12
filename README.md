This repo is what I used to get my Sierra EM7455 modem working on my Lenovo
Yoga 370 on Debian stretch. Probably Ubuntu is the same, I have not tested.
I am also running a stretch-backports kernel, and I have disabled
'predictable interface names' so my wwan interfaces is called wwan0
following the traditional pattern, if predictable interface names are
active your device may be called something like wwp0s20f0u2i12.

The modem is connected internally by USB and enumrates as

    1199:9079 Sierra Wireless, Inc. 

You can probably make this device work using [ModemManager](https://www.freedesktop.org/wiki/Software/ModemManager/)
as an alternative to this method, which uses Debian's
/etc/network/interfaces configuration.

* wwan.sh: script to bring up or down the interface e.g. wwan.sh up or wwan.sh down
* wwan_parse_ip_info: perl script to parse output of mbimcli --query-ip-configuration and generate shell commands to configure wwan device

You will need the following packages for the scripts in this repo

    sudo apt-get install -y libqmi-utils libmbim-utils openresolv

I had the most success using mbim-tools to manage the wwan interface but I
found I needed QMI tools for --dms-set-fcc-authentication to actually make
the modem come alive.

Put the scipts wwan.sh and wwan_parse_ip_info in /etc/network

    sudo install -o root -g root -m755 wwan.sh /etc/network/wwan.sh
    sudo install -o root -g root -m755 wwan_parse_ip_info /etc/network/wwan_parse_ip_info

Add the following to /etc/network/interfaces

    iface wwan0 inet manual
     pre-up /etc/network/wwan.sh start
     pre-down /etc/network/wwan.sh stop

In the script wwan.sh the control device is hardcoded as /dev/cdc-wdm0, this
should be fine unless you have multiple wwan interfaces. The correct
solution would be to pass in the control device for a given wlan interface from
/etc/network/interfaces if it cannot be determined procedurally for a given
wwan interface.

I created a /etc/mbim-network.conf with the APN name for my SIM

    echo 'APN=payandgo.o2.co.uk' | sudo tee /etc/mbim-network.conf

I disabled the PIN on the SIM, however qmicli has PIN management
capabilities, see

    man qmicli

and search for PIN.

Once the network is up wwan.sh will use mbimcli to query what the IP, DNS
and default route settings are for the wwan interface as these are not set
automatically, and I found a DHCP client on the the wwan interface does not
help. Hence the script wwan_parse_ip_info will parse the output of
mbimcli --query-ip-configuration and generate suitable shell script to set
up the interface (at least for IPv4, I haven't been able to see the output
of mbimcli --query-ip-configuration for IPv6.

    ifup wlan0

[https://wiki.archlinux.org/index.php/ThinkPad_mobile_internet]
[https://www.kernel.org/doc/Documentation/networking/cdc_mbim.txt]
