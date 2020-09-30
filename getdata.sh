#/bin/bash
touch ~/.curlrc
echo '-w "dnslookup: %{time_namelookup} | connect: %{time_connect} | appconnect: %{time_appconnect} | pretransfer: %{time_pretransfer} | starttransfer: %{time_starttransfer} | total: %{time_total} | size: %{size_download}\n' >> ~/.curlrc
NOW=$(TZ=America/Havana date +"%d%m%Y_%H%M")
sleep 60
mkdir output
for i in `cat ../ips`; do nslookup $i | grep name | awk '{print $4}' > output/nslookupip-$NOW-$i ; done 
for i in `cat ../ips`; do mtr --report $i | grep -v ^Start > output/tracerip-$NOW-$i ; done
for i in `cat ips`; do curl -so /dev/null $i > output/outputcurl-$NOW-$i; done
