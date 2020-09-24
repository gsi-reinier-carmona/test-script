#/bin/bash
for i in `cat ips`; do nslookup $i | grep name | awk '{print $4}' > nslookupip-$i ; done 
for i in `cat ips`; do mtr --report $i | grep -v ^Start > tracerip-$i ; done
