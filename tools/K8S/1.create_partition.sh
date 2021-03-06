#!/bin/bash

#edited by JC
#j.kwon@f5.com

#https://clouddocs.f5.com/containers/v2/kubernetes/kctlr-use-bigip-k8s.html#use-bigip-k8s-flannel

#if [[ $# == 0 ]]
#then
#     echo -e "\033[92m---------------------  How to use ------------------------------\033[0m"
#     echo -e "\033[92m|You should type what you want to deploy policy file           |\033[0m" 
#     echo -e "\033[92m|Ex)./gtm_manager.sh get [pool/server/datacenter/wideip]       |\033[0m"
#     echo -e "\033[92m----------------------------------------------------------------\033[0m"
#  exit 1;
#fi

name="$(cat ~/.ssh/.user)"
password="$(cat ~/.ssh/.password)"

bigip1="15.164.66.252"
bigip2="15.164.66.43"
token1=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$bigip1/mgmt/shared/authn/login | jq -r .token.token)
token2=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$bigip2/mgmt/shared/authn/login | jq -r .token.token)


##STEP1. ##create new partition for K8S. change the new_partition name to what you want to create
#new_partition="kubernetes"
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1"  -X POST -d '{"name":"'$new_partition'", "fullPath": "/'$new_partition'", "subPath": "/"}' https://$bigip1/mgmt/tm/sys/folder | jq -r .

##STEP2. ## disable vxlan configsync on each device
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X PUT -d '{"value":"disable"}' https://$bigip1/mgmt/tm/sys/db/iptunnel.configsync | jq -r .
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token2" -X PUT -d '{"value":"disable"}' https://$bigip2/mgmt/tm/sys/db/iptunnel.configsync | jq -r .
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X POST -d '{"name": "fl-vxlan","partition": "Common","defaultsFrom": "/Common/vxlan", "floodingType": "none","port": 8472 }' https://$bigip1/mgmt/tm/net/tunnels/vxlan | jq -r .
#sleep 3

##STEP3. ## sync ; change the dg name 
#dg="bigip-ve-dg"
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X POST -d '{"command":"run","options":[{"force-full-load-push to-group":"'$dg'"}]}' https://$bigip1/mgmt/tm/cm/config-sync | jq -r .
#sleep 3
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1"  -X POST -d '{"name": "flannel_vxlan","partition": "Common","key": 1,"localAddress": "10.10.2.6","profile": "/Common/fl-vxlan" }' https://$bigip1/mgmt/tm/net/tunnels/tunnel | jq -r .
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token2"  -X POST -d '{"name": "flannel_vxlan","partition": "Common","key": 1,"localAddress": "10.10.2.7","profile": "/Common/fl-vxlan" }' https://$bigip2/mgmt/tm/net/tunnels/tunnel | jq -r .

#sleep 10
##STEP4. ## take mac-address of flannel vxlan interface
#curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X GET https://$bigip1/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats?options=all-properties | jq -r '.entries."https://localhost/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats"."nestedStats".entries.macAddr.description'
#macAddr1=$(curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X GET https://$bigip1/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats?options=all-properties | jq -r '.entries."https://localhost/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats"."nestedStats".entries.macAddr.description')
#macAddr2=$(curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token2" -X GET https://$bigip2/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats?options=all-properties | jq -r '.entries."https://localhost/mgmt/tm/net/tunnels/tunnel/~Common~flannel_vxlan/stats"."nestedStats".entries.macAddr.description')

##STEP5. ## Create bigip node (vxlan)
#sed -e "s/MAC_ADDR/$macAddr1/g" bigip1-node.yaml | kubectl create -f -
#sed -e "s/MAC_ADDR/$macAddr2/g" bigip2-node.yaml | kubectl create -f -

##STEP6. ## Create vxlan-local self-ip. change ip address what you want to use
Addr1="10.244.124.10/16"
Addr2="10.244.124.11/16"
Addr3="10.244.124.9/16"
curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X POST -d '{"name": "vxlan-local","partition": "Common","address": "'$Addr1'", "floating": "disabled","vlan": "/Common/flannel_vxlan"}' https://$bigip1/mgmt/tm/net/self | jq -r .
curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token2" -X POST -d '{"name": "vxlan-local","partition": "Common","address": "'$Addr2'", "floating": "disabled","vlan": "/Common/flannel_vxlan"}' https://$bigip2/mgmt/tm/net/self | jq -r .
curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token1" -X POST -d '{"name": "vxlan-local-floating","partition": "Common","address": "'$Addr3'", "floating": "enabled","vlan": "/Common/flannel_vxlan"}' https://$bigip1/mgmt/tm/net/self | jq -r .
curl -sk -H "content-type: application/json" -H "X-F5-Auth-Token: $token2" -X POST -d '{"name": "vxlan-local-floating","partition": "Common","address": "'$Addr3'", "floating": "enabled","vlan": "/Common/flannel_vxlan"}' https://$bigip2/mgmt/tm/net/self | jq -r .

##STEP7. ## Create serviceaccount
#kubectl create serviceaccount bigip-ctlr -n kube-system
#kubectl create -f f5-k8s-sample-rbac.yaml

##STEP8. ## Create BIG-IP kubectl secret
#printf "##############################################\n"
#printf "Create BIG-IP secret\n"
#printf "##############################################\n\n\n"
#kubectl create secret generic bigip-login --namespace kube-system --from-literal=username=admin --from-literal=password=admin@Demo

##STEP9. ## Deploy F5 BIG-IP CC
#echo "Deploy BIG-IP CC\n"

#kubectl create -f f5-cc-deployment.yaml -n kube-system
#kubectl create -f f5-cc-deployment2.yaml -n kube-system
