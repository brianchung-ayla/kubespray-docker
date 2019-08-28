#!/bin/bash



kubedep() {
sudo docker run -d --name kubespray-docker \
-v /home/${USER}/.ssh:/root/.ssh \
-v ${PWD}/KubeAutomation:/tmp/KubeAutomation \
kubespray-docker $1 $2

docker logs -f kubespray-docker
docker rm -f kubespray-docker
}


ACTION=$1


case $ACTION in
  'deploy' )
    cp host_output/output.yml KubeAutomation/vars/output.yml
    cd /home/${USER}/kube-automation/KubeAutomation/playbook && ansible-playbook prepare.yml && cd -
    cd /home/${USER}/kube-automation/KubeAutomation/playbook && ansible-playbook gen_cert.yml && cd -
    cd /home/${USER}/kube-automation/KubeAutomation/playbook && ansible-playbook copy_cert.yml && cd -
    sudo cp KubeAutomation/config/hosts.ini /etc/ansible/hosts

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

  'debug' )
    sudo docker run -it --rm --entrypoint=bash --name kubespray-docker \
    -v /home/${USER}/.ssh:/root/.ssh \
    -v ${PWD}/KubeAutomation:/tmp/KubeAutomation \
    kubespray-docker
    ;;

  * )
    echo "unknown action!"
    exit 0
esac
