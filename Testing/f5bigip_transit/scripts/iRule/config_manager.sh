#!/bin/bash

#edited by JC
#j.kwon@f5.com

#https://clouddocs.f5.com/training/community/programmability/html/class3/module1/lab2.html
##https://support.f5.com/csp/article/K11799414

if [ $# == 0 ]
then
     echo -e "\033[92m---------------------  How to use ------------------------------\033[0m"
     echo -e "\033[92m| You should type what you want to check[create/del]           |\033[0m" 
     echo -e "\033[92m| Ex)./config_manager.sh check ; check whole rules             |\033[0m"
     echo -e "\033[92m| Ex)./config_manager.sh check [rule name] ; check named rule  |\033[0m"
     echo -e "\033[92m| Ex)./config_manager.sh create ; create new rule              |\033[0m"
     echo -e "\033[92m----------------------------------------------------------------\033[0m"
  exit 1;
fi

dir=$(pwd)
name="$(cat ~/.ssh/.user)"
password="$(cat ~/.ssh/.password)"

#prefix=$(cd /tf/caf/landingzones/landingzone_vdc_demo && terraform output prefix)
#rg=$prefix-hub-network-transit
#lb_name=Azure-LB-Public-IP

ip="10.65.32.29"
token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)

if [  $1 == check ]
then
  if [ $2 == 0 ]
  then
    echo -e "\033[32mChecing $1's rules ....... \033[0m "
    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/ltm/rule/ | jq -r .
    echo -e "\033[32m ------------------------------------------------------------------\033[0m "
  else
    echo -e "\033[32mChecing $1's rules ....... \033[0m "
    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/ltm/rule/$2 | jq -r .
    echo -e "\033[32m ------------------------------------------------------------------\033[0m "
  fi

elif [ $1 == create ]
then
  echo -e "\033[32mCreating a new iRule ....... \033[0m "
  #curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X POST https://$ip/mgmt/tm/ltm/rule -d '{"name":"iRule_Demo","apiAnonymous":"when HTTP_REQUEST {\n  if { [HTTP::uri] ends_with \"test\" } {\n    pool test_pool\n  }\n}"}' | jq -r .
   curl -sk -H "Content-Type: test/x-yaml" -H "X-F5-Auth-Token: $token" -X POST --data-binary @$2 https://$ip/mgmt/shared/appsvcs/declare | jq -r .
  echo -e "\033[32m ------------------------------------------------------------------\033[0m "

elif [ $1 == del ]
then
  if [ $2 == 0 ]
  then
    echo -e "\033[32mPlease type rule name....... \033[0m "
  else
    echo -e "\033[32mDeleting rule name $2....... \033[0m "
    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X DELETE https://$ip/mgmt/tm/ltm/rule/$2 | jq -r .
  fi

fi
