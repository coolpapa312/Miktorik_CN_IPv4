#!/bin/bash

wget -c http://ftp.apnic.net/stats/apnic/delegated-apnic-latest

cat delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' | cat > ipv4.txt
cat > CN << EOF
/log info "Import cn ipv4 cidr list..."
/ip firewall address-list remove [/ip firewall address-list find list=CN]
/ip firewall address-list
EOF
cat ipv4.txt | awk '{ printf(":do {add address=%s list=CN} on-error={}\n",$0) }' >> CN
echo "}" >> CN