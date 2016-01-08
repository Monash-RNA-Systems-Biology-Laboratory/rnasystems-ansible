#!/bin/bash

# Try
#
#   tcpdump port 53
#
# for suggestions for domains to whitelist.


read -d '' domains </root/whitelist.txt

ufw --force reset
ufw default deny incoming
ufw default reject outgoing

# Allow in from wired Monash servers and staff wireless lan
ufw allow in proto tcp to any port 22 from 130.194.0.0/16
ufw allow in proto tcp to any port 22 from 49.127.0.0/17

ufw logging on

for entry in $domains; do
        echo /$entry/
        case $entry in
                \#*)
                ;;

                *[0-9])
                ufw allow out to $entry
                ;;

                *)
                host $entry | awk '/has address/{print $4}' \
                        | xargs -iADDR ufw allow out to ADDR
                ;;
        esac
done

ufw --force enable
ufw status



