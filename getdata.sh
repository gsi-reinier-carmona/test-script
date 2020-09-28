#/bin/bash
NOW=$(TZ=America/Havana date +"%d%m%Y_%H%M")
mkdir output
for i in `cat ips`; do nslookup $i | grep name | awk '{print $4}' > output/nslookupip-$NOW-$i ; done 
for i in `cat ips`; do mtr --report $i | grep -v ^Start > output/tracerip-$NOW-$i ; done
