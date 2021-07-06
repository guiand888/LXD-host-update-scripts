#!/bin/bash

# Alpine variant

# Verbose
#set -x


LXC="/snap/bin/lxc"
AWK="/usr/bin/awk"
CURRENTDATE=`date +"%Y%m%d-%H%M"`
HEALTHCHECK=uuid

# Get containers list
clist="$(${LXC} list -cns,image.os | ${AWK} '!/NAME/{ if ( ( $4 == "RUNNING" ) && ( $6 == "Alpine" ) ) print $2}')"
 
# Update
for c in $clist
do
        echo "Taking a snapshot for \"$c\"..."
        ${LXC} snapshot $c update-$CURRENTDATE
        echo "Updating system for \"$c\"..."
        ${LXC} exec $c -- apk update
        ${LXC} exec $c -- apk upgrade
        echo "Running local update script for \"$c\"..."
        ${LXC} exec $c -- bash /usr/local/bin/localupdate.sh
done
curl -fsS --retry 5 -o /dev/null https://hc-ping.com/$HEALTHCHECK
