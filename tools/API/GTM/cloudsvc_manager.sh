#!/bin/bash

#edited by JC
#j.kwon@f5.com

#https://clouddocs.f5.com/cloud-services/latest/f5-cloud-services-GSLB-Guidelines_DNS_API.html

if [ $# ==  0 ]
then
     echo -e "\033[92m---------------------  How to use ----------------------------------------------\033[0m"
     echo -e "\033[92m| You should type what you want to check[create/del]                            |\033[0m" 
     echo -e "\033[92m| Ex)./config_manager.sh get [user/continents/countires/regions/subscriptioin]  |\033[0m"
     echo -e "\033[92m| Ex)./config_manager.sh create [xxx/xxxx] ; check named rule                   |\033[0m"
     echo -e "\033[92m| Ex)./config_manager.sh modify [xxx/xxxx] ; rule                               |\033[0m"
     echo -e "\033[92m--------------------------------------------------------------------------------\033[0m"
  exit 1;
fi

dir=$(pwd)
name="$(cat ~/.ssh/.duser)"
password="$(cat ~/.ssh/.dpassword)"


token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'"}' https://api.cloudservices.f5.com/v1/svc-auth/login | jq -r .access_token)
id=$(curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET https://api.cloudservices.f5.com/v1/svc-account/user | jq -r .primary_account_id)
sub_id=$(curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions?status=_allStatusFilter&account_id=$id" | jq -r .subscriptions[1].subscription_id)


if [  "$1" ==  "get" ]
then
  if [ "$2" ==  "user" ]
  then
    echo -e "\033[32mGetting user info ................................... \033[0m "
    curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET https://api.cloudservices.f5.com/v1/svc-account/$2 | jq -r .
    echo -e "\033[32m ----------------------------------------------------\033[0m "

  elif [ "$2" ==  "continents" ]
  then
    echo -e "\033[32mGetting continents info ................................... \033[0m "
    curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET https://api.cloudservices.f5.com/v1/svc-geo/$2 | jq -r .
    echo -e "\033[32m ----------------------------------------------------\033[0m "

  elif [ "$2" ==  "countries" ]
  then
    echo -e "\033[32mGetting country info ................................... \033[0m "
    curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-geo/$2" | jq -r .
    echo -e "\033[32m ----------------------------------------------------\033[0m "

  elif [ "$2" ==  "regions" ]
  then
    echo -e "\033[32mGetting region info ........................................ \033[0m "
    curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-geo/$2" | jq -r .
    echo -e "\033[32m-------------------------------------------------------------\033[0m "

  elif [ "$2" ==  "subscription" ]
  then
    echo -e "\033[32mGetting subscription info .................................. \033[0m "
    count=$(curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions?status=_allStatusFilter&account_id=$id" | jq -r '.subscriptions | length')
    if [ count > 1 ]
    then  
      for (( i=0; i < $count; i++ ))
      do
      sub_id=$(curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions?status=_allStatusFilter&account_id=$id" | jq -r '.subscriptions['$i'].subscription_id')
      sub_name=$(curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X GET "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions?status=_allStatusFilter&account_id=$id" | jq -r '.subscriptions['$i'].service_instance_name')
      echo -e "Subscription name is \033[32m$sub_name\033[0m and ID is \033[32m$sub_id\033[0m"
      done
    fi
    echo -e "\033[32m-----------------------------------------------------------\033[0m "

  #else
  #  echo -e "\033[32mYou need to type what you want to see item\033[0m "
  fi

elif [ "$1" ==  "create" ]
then
  echo -e "\033[32mCreating GSLB Services ..................................... \033[0m "
  curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X POST -d @$2 "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions" | jq -r .
  echo -e "\033[32m-------------------------------------------------------------\033[0m "

elif [ "$1" ==  "activate" ]
then
  SUBSCRIPTION_ID=$2
  echo -e "\033[32mActivating GSLB Service....................................... \033[0m "
  curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X POST "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions/$SUBSCRIPTION_ID/activate" | jq -r .
  echo -e "\033[32m-------------------------------------------------------------\033[0m "

elif [ "$1" ==  "delete" ]
then
  SUBSCRIPTION_ID=$2
  echo -e "\033[32mDeleting GSLB Services ..................................... \033[0m "
  curl -sk -H "Accept: application/json" -H "Authorization: Bearer $token" -X POST "https://api.cloudservices.f5.com/v1/svc-subscription/subscriptions/$SUBSCRIPTION_ID/retire" | jq -r .
  echo -e "\033[32m-------------------------------------------------------------\033[0m "


fi
