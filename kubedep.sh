#!/bin/bash


cp host_output/output.yml KubeAutomation/vars/output.yml
cp KubeAutomation/config/hosts.ini /etc/ansible/hosts
cd /root/kubespray-docker/KubeAutomation/playbook && ansible-playbook prepare.yml && cd -

kubedep() {
docker run -d --name kubespray-docker \
-v /root/.ssh:/root/.ssh \
-v ${PWD}/KubeAutomation:/tmp/KubeAutomation \
kubespray-docker $1 $2

docker logs -f kubespray-docker
docker rm -f kubespray-docker
}


ACTION=$1


case $ACTION in
  'deploy' )
    kubedep deploy
    ;;

  'reset' )
    kubedep reset
    ;;

  'scale' )
    kubedep scale
    ;;

  'upgrade' )
    kubedep upgrade $2
    ;;

  '*' )
    echo "unknown action!"
    exit 0
esac
