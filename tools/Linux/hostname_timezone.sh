#!/bin/bash

#edited by JC
#j.kwon@f5.com


#if [[ $# == 0 ]]
#then
#     echo -e "\033[92m--------------------  How to use ----------------------------------------\033[0m"
#     echo -e "\033[92m| You need to type username, remote host info and timezone              |\033[0m" 
#     echo -e "\033[92m| Ex)./hostname_timzone.sh                                              |\033[0m"
#     echo -e "\033[92m-------------------------------------------------------------------------\033[0m"

#     exit 1;
#fi

echo -e "\033[92m Enter remote access username \033[0m"
read -p 'username: ' ruser
echo -e "\033[92m Enter remote ip or domain-name to access remote host \033[0m"
read -p 'ip or domain-name: ' remote
echo -e "\033[92m Enter new hostname what you want to change \033[0m"
read -p 'new-hostname: ' new_hostname
echo -e "\033[92m Enter new timezone \033[0m"
read -p 'new_timezone: ' new_timezone

#to check current timezone; timedatectl
#to check timezone list; timedatectl list-timezones
ssh -t $ruser@$remote <<EOF
sudo hostnamectl set-hostname $new_hostname 
exec bash 
sudo timedatectl set-timezone $new_timezone
timedatectl 
sleep 3
exit
EOF


