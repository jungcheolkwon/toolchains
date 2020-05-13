#!/bin/bash

#edited by JC
#j.kwon@f5.com

#https://clouddocs.f5.com/training/community/programmability/html/class3/module1/lab2.html
#https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/setting-up-consumer.html

if [ $# == 0 ]
then
     echo -e "\033[92m---------------------  How to use ------------------------------\033[0m"
     echo -e "\033[92m| You should type what you want to deploy policy file           |\033[0m" 
     echo -e "\033[92m| Ex)./policy_pusher.sh afm.json or asm.json                    |\033[0m"
     echo -e "\033[92m----------------------------------------------------------------\033[0m"
  exit 1;
fi

name="$(cat ~/.ssh/.suser)"
#password="$(cat ~/.ssh/.spassword)"
password="admin"

#ip="15.164.66.252"
ip="13.125.42.182:8443"
#ip0="15.164.66.43"

#  token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'"}' https://api.cloudservices.f5.com/v1/svc-auth/login | jq -r .access_token)

function create() {
  
	  echo -e "\033[32m.Creating $1 Telemetry Consumer at BIP1...... \033[0m "
    token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)
    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X POST -d @consumer/$1.json https://$ip/mgmt/shared/telemetry/declare | jq -r .
    echo ""
	  echo -e "\033[32m.Creating $1 Telemetry Consumer at BIP2...... \033[0m "
    token0=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip0/mgmt/shared/authn/login | jq -r .token.token)
    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token0" -X POST -d @consumer/$1.json https://$ip0/mgmt/shared/telemetry/declare | jq -r .
    echo -e "\033[32m--------------------------------------------\033[0m "

}

if [ "$1" = "get" ]
then
  echo -e "\033[32mGetting Telemetry info............... \033[0m "
  token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)
  curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/shared/telemetry/info | jq -r .
  echo -e "\033[32m ---------------------\033[0m "

elif ( [[ "$1" = "create" ]] && [[ "$2" = "beacon" ]] )
then
  passphrase=($3)
  if [ "$passphrase" = "" ]
  then
    echo -e "\033[32m------------------------------------------------------------\033[0m "
    echo -e "\033[32myou should need to check passphrase then type after beacon!!\033[0m "
    echo -e "\033[32m------------------------------------------------------------\033[0m "
  else
    sed -i -e 's/"cipherText": ".*"/"cipherText": "'$passphrase'"/g' consumer/beacon.json
    create $2
  fi

elif ( [[ "$1" = "create" ]] && ([[ "$2" = "splunk" ]] || [[ "$2" = "azure" ]] || [[ "$2" = "aws" ]] || [[ "$2" = "graphite" ]] || [[ "$2" = "kafka" ]] || [[ "$2" = "elastic" ]] || [[ "$2" = "sumo" ]] || [[ "$2" = "statsd" ]]) )
then
  create $2

elif ( [[ "$1" = "create" ]] && ([[ "$2" = "bip-pv" ]] || [[ "$2" = "statsd" ]]) )
then
  create $2

elif [ $1 == del ]
then
	echo -e "\033[32m.Deleting Telemetry Listner at BIP1...... \033[0m "
  token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)
#  curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X POST -d @example.json https://$ip/mgmt/shared/telemetry/declare | jq -r .
	echo -e "\033[32m.Deleting Telemetry Listner at BIP2...... \033[0m "
  token0=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip0/mgmt/shared/authn/login | jq -r .token.token)
#  curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token0" -X POST -d @example.json https://$ip0/mgmt/shared/telemetry/declare | jq -r .
  echo -e "\033[32m ---------------------\033[0m "


fi
