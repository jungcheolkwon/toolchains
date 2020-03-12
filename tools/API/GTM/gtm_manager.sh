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

name="$(cat ~/.ssh/.ouser)"
password="$(cat ~/.ssh/.opassword)"

function GET () {
  echo -e "\033[32mGetting GTM pool ...................... \033[0m "
  curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r '.items[] | .name + " " + .loadBalancingMode'
  echo -e "\033[32m --------------------------------------\033[0m "
}

function CREATE () {
  echo -e "\033[32mCreating a datacenter ................. \033[0m "
  curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X POST https://$ip/mgmt/tm/gtm/datacenter -d '{ "name": "'$dname'"}' | jq -r .;
  echo -e "\033[32m --------------------------------------\033[0m "
}

function DELETE () {
  echo -e "\033[32mDeleting a pool ....................... \033[0m "
  curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X DELETE https://$ip/mgmt/tm/gtm/pool/a -d '{ "name": "'$pname'"}' | jq -r .;
  echo -e "\033[32m --------------------------------------\033[0m "
}

function MODIFY () {
  echo -e "\033[32mModify pool load-balance mode ......... \033[0m "
  curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH https://$ip/mgmt/tm/gtm/pool/a/$pname/ -d '{ "loadBalancingMode": "'$lbmode'"}' | jq -r .;
  echo -e "\033[32m --------------------------------------\033[0m "

}

ip="10.65.32.29"
token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip/mgmt/shared/authn/login | jq -r .token.token)

if [ "$1" == "get" ]
then
  if [ "$2" == "pool" ]
  then
    echo -e "\033[32mGetting GTM pool ................ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r '.items[] | .name + " " + .loadBalancingMode'
    echo -e "\033[32m---------------------------------------\033[0m "

    if [ "$3" == "member" ]
    then
      echo -e "\033[32mGetting GTM pool member detail ............. \033[0m "
      pname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r .items[0].name)
      curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a/$pname/members | jq -r .

    elif [ "$3" == "detail" ]
    then
      echo -e "\033[32mGetting GTM pool detail ............. \033[0m "
      curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r .

    else
      #  pname=$3
      echo -e "\033[32mYou can use more option[member/detail with pool] ......... \033[0m "
      #  curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a/$pname/members | jq -r .items[0].name
    fi

  elif [ "$2" == "wideip" ]
  then
    echo -e "\033[32mGetting GTM wideip ................ \033[0m "
    #curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r '.items[] | .name + " " + .poolLbMode'
    echo -e "\033[32m---------------------------------------\033[0m "
    
  elif [ "$2" == "datacenter" ]
  then
    echo -e "\033[32mGetting GTM datacenter ................ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/datacenter/ | jq -r .items[].name
    echo -e "\033[32m---------------------------------------\033[0m "
    
  elif [ "$2" == "listener" ]
  then
    echo -e "\033[32mGetting GTM listener ................ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/listener | jq -r '.items[] | .name + " " + .address'
    echo -e "\033[32m---------------------------------------\033[0m "
    
  elif [ "$2" == "server" ]
  then
    echo -e "\033[32mGetting GTM server ................ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/server | jq -r '.items[] | .name + " " + .addresses[].name'
    echo -e "\033[32m---------------------------------------\033[0m "
  
  else
    echo -e "\033[32mDisplaying GTM detail info ............ \033[0m "
    curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "
  fi

elif [ "$1" == "create" ]
then
  if [ "$2" == "datacenter" ]
  then
    dname=$3
    echo -e "\033[32mCreating a datacenter ................. \033[0m "
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X POST https://$ip/mgmt/tm/gtm/datacenter -d '{ "name": "'$dname'"}' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  elif [ "$2" == "pool" ]
  then
    pname=$3
    echo -e "\033[32mCreating a pool ....................... \033[0m "
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X POST https://$ip/mgmt/tm/gtm/pool/a -d '{ "name": "'$pname'"}' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  else  
	  echo -e "\033[32mYou need any value for each option ....\033[0m "
  fi

elif [ "$1" == "modify" ]
then
  if [ "$2" == "wideip" ] && [ "$3" == "mode" ]
  then
    lbmode=$4
    echo -e "\033[32mModify wideip pool load-balance mode ......... \033[0m "
    #curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .
    wname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .items[0].name)
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH https://$ip/mgmt/tm/gtm/wideip/a/$wname -d '{ "poolLbMode": "'$lbmode'"}' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  elif [ "$2" == "wideip" ] && [ "$3" == "ratio" ]
  then
    ratio1=$4
    ratio2=$((10 - $ratio1))
    echo -e "\033[32mModify wideip pool member ratio ............ \033[0m "
    wname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .items[0].name)
    pname0=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .items[0].pools[0].name)
    pname1=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/wideip/a | jq -r .items[0].pools[1].name)

    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH https://$ip/mgmt/tm/gtm/wideip/a/$wname -d '{ "pools": [ { "name": "'$pname0'", "ratio": "'$ratio1'"}, { "name": "'$pname1'", "ratio": "'$ratio2'"} ] }' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  elif [ "$2" == "pool" ] && [ "$3" == "mode" ]
  then
    lbmode=$4
    echo -e "\033[32mModify pool load-balance mode ......... \033[0m "
    pname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r .items[0].name)
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH https://$ip/mgmt/tm/gtm/pool/a/$pname/ -d '{ "loadBalancingMode": "'$lbmode'"}' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  elif [ "$2" == "pool" ] && [ "$3" == "ratio" ]
  then
    ratio1=$4
    ratio2=$((10 - $ratio1))
    echo -e "\033[32mModify pool member ratio ............ \033[0m "
    pname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a | jq -r .items[0].name)
    mname=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a/$pname/members | jq -r '.items[0] | .subPath + "/" + .name')
    mname1=$(curl -sk -H "X-F5-Auth-Token: $token" -X GET https://$ip/mgmt/tm/gtm/pool/a/$pname/members | jq -r '.items[1] | .subPath + "/" + .name')

    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH https://$ip/mgmt/tm/gtm/pool/a/$pname -d '{ "members": [ { "name": "'$mname'", "ratio": "'$ratio1'"}, { "name": "'$mname1'", "ratio": "'$ratio2'"} ] }' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "
  else
    echo -e "\033[32mYou need type any value for wideip[pool] mode or ratio ............ \033[0m "
    echo -e "\033[32mex)./gtm_manager modify wideip[pool] mode roun-robin or ratio       \033[0m "
    echo -e "\033[32mex)./gtm_manager modify wideip[pool] ratio 7                        \033[0m "
  fi  

elif [ "$1" == "del" ]
then
  if [ "$2" == "datacenter" ]
  then
    dname=$3
    echo -e "\033[32mDeleting a datacenter ................. \033[0m "
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X DELETE https://$ip/mgmt/tm/gtm/datacenter -d '{ "name": "'$dname'" }' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  elif [ "$2" == "pool" ]
  then
    pname=$3
    echo -e "\033[32mDeleting a pool ....................... \033[0m "
    curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token" -X DELETE https://$ip/mgmt/tm/gtm/pool/a/ -d '{ "name": "'$pname'" }' | jq -r .
    echo -e "\033[32m---------------------------------------\033[0m "

  else  
	  echo -e "\033[32mYou need any value for each option ....\033[0m "
  fi
    
fi