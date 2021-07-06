#!/bin/bash

# Ubuntu variant

# Verbose
#set -x

APT="/usr/bin/apt-get"
LXC="/snap/bin/lxc"
AWK="/usr/bin/awk"
CURRENTDATE=`date +"%Y%m%d-%H%M"`
HEALTHCHECK=uuid

# Get containers list
clist="$(${LXC} list -cns,image.os | ${AWK} '!/NAME/{ if ( ( $4 == "RUNNING" ) && ( $6 == "ubuntu" ) ) print $2}')"

# Update
for c in $clist
do
        echo "Taking a snapshot for \"$c\"..."
        ${LXC} snapshot $c update-$CURRENTDATE
        echo "Updating system for \"$c\"..."
        ${LXC} exec $c ${APT} -- -qq update
        ${LXC} exec $c ${APT} -- -qq -y upgrade
        ${LXC} exec $c ${APT} -- -qq -y clean
        ${LXC} exec $c ${APT} -- -qq -y autoclean
        echo "Running local update script for \"$c\"..."
        ${LXC} exec $c -- bash /usr/local/bin/localupdate.sh
done
curl -fsS --retry 5 -o /dev/null https://hc-ping.com/$HEALTHCHECK
