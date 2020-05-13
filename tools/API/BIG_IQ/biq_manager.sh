#!/bin/bash

#edited by JC
#j.kwon@f5.com

#https://clouddocs.f5.com/training/community/programmability/html/class3/module1/lab2.html
#https://support.f5.com/csp/article/K86953011

if [[ $# == 0 ]]
then
     echo -e "\033[92m---------------------  How to use ------------------------------\033[0m"
     echo -e "\033[92m|You should type what you want to deploy policy file           |\033[0m" 
     echo -e "\033[92m|Ex)./gtm_manager.sh get [pool/server/datacenter/wideip]       |\033[0m"
     echo -e "\033[92m|Ex)./gtm_manager.sh modify wideip[pool] mode[ratio]           |\033[0m"
     echo -e "\033[92m----------------------------------------------------------------\033[0m"
  exit 1;
fi

name="$(cat ~/.ssh/.duser)"
password="$(cat ~/.ssh/.dpassword)"

ip="10.1.1.4"

token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"RadiusServer"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)
#echo "$token"
if [[ ( "$1" ==  "push" ) && ( $2 == '' ) ]]
then
    echo -e "\033[32mPushing config with AS3................ \033[0m "
    curl -sk -H "Content-Type: test/x-yaml" -H "X-F5-Auth-Token: $token" -X POST -d @as3.json https://$ip/mgmt/shared/appsvcs/declare?async=true | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

elif [[ ( "$1" ==  "push" ) && ( $2 == 'templates' ) ]]
then
    echo -e "\033[32mPushing AS3 template to $ip................ \033[0m "
    curl -sk -H "Content-Type: test/x-yaml" -H "X-F5-Auth-Token: $token" -X POST -d @as3_tpt https://$ip/mgmt/cm/global/appsvcs-templates | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "


elif [ "$1" == "get" ]
then
#    id="i$2"
    id = "25e162b2-8f5c-4e7f-92a8-4dfef393a938"
    echo -e "\033[32mGetting config ........................ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/shared/appsvcs/task/$id | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

else  
          echo -e "\033[32mYou need any value for each option ....\033[0m "
fi
