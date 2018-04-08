#!/bin/sh

set -e

#apt-get install -y libqmi-utils libmbim-utils

CTRL_DEVICE=/dev/cdc-wdm0
WWAN_INTERFACE=`qmicli -d $CTRL_DEVICE --get-wwan-iface`
IP_INFO_PARSER="/etc/network/wwan_parse_ip_info"

case $1 in
  start)
    qmicli -d $CTRL_DEVICE --device-open-mbim --dms-set-fcc-authentication || true
    bash mbim-network $CTRL_DEVICE start || true
    mbimcli -d $CTRL_DEVICE --query-ip-configuration --no-open=999 --no-close | $IP_INFO_PARSER $WWAN_INTERFACE | sh -x
  ;;
  stop)
    bash mbim-network $CTRL_DEVICE stop || true
    ip link set dev $WWAN_INTERFACE down
    resolvconf -d $WWAN_INTERFACE || true
  ;;
esac
