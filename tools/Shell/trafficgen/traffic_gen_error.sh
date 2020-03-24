#!/bin/bash

server=10.1.10.8:80

arrPath=('/' '/a' '/b' '/d' '/e' '/f' '/g' )
arrPath2=('sa' 'tz' 'ue' 'vere' 'wxdf' 'xere' 'yxx' )
arrPath3=('e' 'g' '/dfdi' 'erek' '/afdm' '/sadfd' 'a' )

arrRespCode=(404 404 404 404 404 404 404)
arrRespSize=(0 0 0 0 0 0 0 0 0)

arrUserAgent=('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36' 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:40.0) Gecko/20100101 Firefox/40.0' 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1' 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36' )

arrSleepTime=(50 60 50 60 20 20 70)

echo "Traffic Generator start executing for $1 rounds."

for (( i=0; i < $1; ++i ))
do
    seed=`echo "$(od -An -N4 -tu4 /dev/urandom) % 7" | bc`
    seed2=`echo "$(od -An -N4 -tu4 /dev/urandom) % 7" | bc`
    seed3=`echo "$(od -An -N4 -tu4 /dev/urandom) % 7" | bc`

    dynTime=`echo "$(od -An -N4 -tu4 /dev/urandom) % 100" | bc`

    dynTime=$(($dynTime + ${arrSleepTime[$seed]}))

    xff=`printf "%d.%d.%d.%d\n" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))"`

    ua=${arrUserAgent[`echo "$seed % 4" | bc`]}

    command="curl -sk $server${arrPath[$seed]}${arrPath2[$seed2]}${arrPath3[$seed3]} -H 'x-ths-resp-code: ${arrRespCode[$seed]}' -H 'x-ths-resp-size: ${arrRespSize[$seed]}' -H 'x-ths-sleep-time: $dynTime' -H 'x-forwarded-for: $xff' -H 'user-agent: $ua' | jq ."
    eval $command

    sleep 0.1

done
