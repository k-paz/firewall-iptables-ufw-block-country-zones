#!/bin/bash
echo "...preparing soure ip ranges for blocking..."
rm *.zone
# put the 2letter country code tld to block at the for loop condition right below:
for CCTLD in cn kp ru ua by iq af ir ae sg hk kw kg ; do
	wget -P . https://www.ipdeny.com/ipblocks/data/aggregated/${CCTLD}-aggregated.zone
done
cat *.zone | sort | uniq > ips-z.deny
rm *.zone
echo "clearing and setting up ipset:"
ipset -exist flush zablokuj
ipset -exist create zablokuj hash:net
echo "...and now it takes a few minutes to populate the ipset from file -> loading..."
for line in `cat ips-z.deny`; do ipset add zablokuj $line ; done 
# echo "...finishing by adding up the matching rule for IPTABLES INPUT chain..."
# iptables -A INPUT -m set --match-set zablokuj src -j DROP
echo "...finishing by adding up the matching rule for UFW chain..."
iptables -A ufw-before-logging-input -m set --match-set zablokuj src -j DROP
# iptables -A ufw-before-input -m set --match-set zablokuj src -j DROP
# iptables -A ufw-user-input -m set --match-set zablokuj src -j DROP
echo "saving ipset to file for quickrestore - ipset restore < ipset.conf"
ipset save > ipset.conf
echo "done."
