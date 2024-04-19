#!/bin/bash
ufw reload
ipset -exist destroy zablokuj
ipset restore < ipset.conf
iptables -A ufw-before-logging-input -m set --match-set zablokuj src -j DROP
echo "done."
