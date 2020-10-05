#/bin/bash
touch ~/.curlrc
n=1
echo '-w "{\"domain\": \"%{url_effective}\" ,\"dnslookup\": \"%{time_namelookup}\" , \"connect\": \"%{time_connect}\" , \"appconnect\": \"%{time_appconnect}\" , \"pretransfer\": \"%{time_pretransfer}\" , \"starttransfer\": \"%{time_starttransfer}\" , \"total\": \"%{time_total}\" , \"size\": \"%{size_download}\"}\n' >> ~/.curlrc
sleep 60
mkdir output
for i in `cat ../ips`; do nslookup $i | grep -v 127.0.0.53| awk -v var=$n 'BEGIN {print "{\"domain\"" ":" "\"'$i'\""} /^Name:/ {N=$2}; /^Address:/ {print ",\"ip" var++"\""  ":" "\"" $2 "\""} END {print "}" }' > output/nslookupip-$i.json ; done
for i in `cat ../ips`; do mtr --json $i | grep -v ^Start > output/tracerip-$i.json ; done
for i in `cat ../ips`; do curl -so /dev/null $i > output/outputcurl-$i.json; done
