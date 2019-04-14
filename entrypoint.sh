#!/bin/bash

set -ex

ansible-playbook /tmp/KubeAutomation/playbook/prepare.yml

cp /tmp/KubeAutomation/config/hosts.ini /kubespray/inventory/mycluster/hosts.ini
cp /tmp/KubeAutomation/config/k8s-cluster.yml /kubespray/inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml
cp /tmp/KubeAutomation/config/addons.yml /kubespray/inventory/mycluster/group_vars/k8s-cluster/addons.yml
cp /tmp/KubeAutomation/config/all.yml /kubespray/inventory/mycluster/group_vars/all/all.yml
cp /tmp/KubeAutomation/config/docker.yml /kubespray/inventory/mycluster/group_vars/all/docker.yml
cp /tmp/KubeAutomation/config/reset.yml /kubespray/reset.yml
cp /tmp/KubeAutomation/config/k8s_app_main.yml /kubespray/roles/kubernetes-apps/ansible/defaults/main.yml
cp /tmp/KubeAutomation/config/k8s_master_main.yml /kubespray/roles/kubernetes/master/defaults/main.yml
cp /tmp/KubeAutomation/config/k8s_node_main.yml /kubespray/roles/kubernetes/node/defaults/main.yml

ACTION=$1

if [ "$2" == "CN" ];then
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root /tmp/KubeAutomation/playbook/copy_download.yml
fi

case $ACTION in
  'deploy' )
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root cluster.yml
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root /tmp/KubeAutomation/playbook/init.yml
    if [ "$2" == "CN" ];then
        ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root /tmp/KubeAutomation/playbook/clean_proxy.yml
    fi
    ;;

  'reset' )
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root reset.yml
    ;;

  'scale' )
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root scale.yml
    ;;

  'upgrade' )
    ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root cluster.yml -e kube_version=$2
    ;;

  '*' )
    echo "unknown action!"
    exit 0
esac
