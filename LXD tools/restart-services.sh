#!/bin/bash

set -x

lxc exec gw-openvpn -- systemctl status openvpn-mullvad-Singapore.service
lxc restart transmission searx jackett radarr v2ray pihole
