#!/bin/bash

if [ "$USER" != "root" ];then
    sed -i 's/root/\home\/${USER}/g' kubedep.sh
    sed -i 's/root/ubuntu/g' KubeAutomation/template/hosts-lab.ini.j2
    sed -i 's/root/ubuntu/g' KubeAutomation/template/hosts.ini.j2
fi

CLOUD=`grep cloud host_output/output.yml|awk '{print $2}'`

if [ "$CLOUD" = "gcp" ];then
  sudo apt-get update
  sudo apt-get install -y docker.io ansible
else
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce ansible
fi

sudo sed -i '/host_key_checking/s/#//g' /etc/ansible/ansible.cfg
docker build -t kubespray-docker .
