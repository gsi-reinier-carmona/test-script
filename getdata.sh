#/bin/bash
touch ~/.curlrc
n=1
DAY=$(TZ=America/Havana date +"%d%m%Y")
TIME=$(TZ=America/Havana date +"%H:%M")
echo '-w "{\"domain\": \"%{url_effective}\" ,\"dnslookup\": \"%{time_namelookup}\" , \"connect\": \"%{time_connect}\" , \"appconnect\": \"%{time_appconnect}\" , \"pretransfer\": \"%{time_pretransfer}\" , \"starttransfer\": \"%{time_starttransfer}\" , \"total\": \"%{time_total}\" , \"size\": \"%{size_download}\"}\n' >> ~/.curlrc
sleep 60
mkdir output
for i in `cat ../ips`; do nslookup $i | grep -v 127.0.0.53| awk -v var=$n 'BEGIN {print "{\"domain\"" ":" "\"'$i'\"\n ,\"day\"" ":" "\"'$DAY'\"\n ,\"time\"" ":" "\"'$TIME'\""} /^Name:/ {N=$2}; /^Address:/ {print ",\"ip" var++"\""  ":" "\"" $2 "\""} END {print "}" }' > output/nslookupip-$i.json ; done
for i in `cat ../ips`; do mtr --json $i | grep -v ^Start > output/tracerip-$i.json ; done
for i in `cat ../ips`; do curl -so /dev/null $i > output/outputcurl-$i.json; done
awk '/"src"/{print "      \"day\""":" " \"'$DAY'\",\n      \"time\"" ":" " \"'$TIME'\","}1' output/tracerip-updates.push.services.mozilla.com > tmp && mv tmp output/tracerip-updates.push.services.mozilla.com
awk '/"src"/{print "      \"day\""":" " \"'$DAY'\",\n      \"time\"" ":" " \"'$TIME'\","}1' output/tracerip-fcm.googleapis.com > tmp && mv tmp output/tracerip-fcm.googleapis.com
awk '{gsub(/}$/,",\"day\"" ":" "\"'$DAY'\"\n ,\"time\"" ":" "\"'$TIME'\"}"); print}' output/outputcurl-updates.push.services.mozilla.com > tmp && mv tmp output/outputcurl-updates.push.services.mozilla.com
awk '{gsub(/}$/,",\"day\"" ":" "\"'$DAY'\"\n ,\"time\"" ":" "\"'$TIME'\"}"); print}' output/outputcurl-fcm.googleapis.com > tmp && mv tmp output/outputcurl-fcm.googleapis.com