echo "Starting to Find SubDomains"
curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([w]*)\.([A-z]))\w+" > SubDomin.txt
echo "Starting Amass"
amass enum -passive -norecursive -noalts -d $1 > SubDomain2.txt
echo "Let's Start Magic's"
curl -s https://dns.bufferover.run/dns?q=.$1 |jq -r .FDNS_A[]|cut -d',' -f2|sort -u > SubDomain3.txt
curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > SubDomain4.txt
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u > SubDomain5.txt
echo "Let's make him TOgether ."
cat SubDomain.txt | cat SubDomain2.txt | cat SubDomain3.txt | cat SubDomain4.txt | cat SubDomain5.txt | httpx -o httpxdone.txt
