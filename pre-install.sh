#!/bin/bash

if [ "$USER" != "root" ];then
    sed -i 's/root/\home\/${USER}/g' kubedep.sh
    sed -i 's/root/ubuntu/g' KubeAutomation/template/hosts-lab.ini.j2
    sed -i 's/root/ubuntu/g' KubeAutomation/template/hosts.ini.j2
fi

apt-get update
apt-get install -y docker ansible
