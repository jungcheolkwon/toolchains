#!/bin/bash

#for i in `cat geoip`
#do
	curl -k  https://bookinfo.f5se.io/productpage?u=normal 
	curl -k https://bookinfo.f5se.io/productpage?u=test
	#echo "--- $i ---" && curl -k --header "X-Forwarded-For: $i" https://bookinfo.f5se.io/productpage?u=normal && curl -k --header "X-Forwarded-For: $i" https://bookinfo.f5se.io/productpage?u=test
#	echo "------ $i ---------"
	sleep 5
#done
