## kubespray-docker

# use host_output/output.yml to define host list & args
* lab mode
```
cp host_output/output.yml.lab host_output/output.yml
```

* production mode
```
cp host_output/output.yml.production host_output/output.yml
```

# use kubedep.sh to do below actions

* deploy k8s cluster
```
./kubedep.sh deploy
```

* reset k8s cluster
```
./kubedep.sh reset
```

* scale k8s cluster
1. kubespray
```
vim /home/ubuntu/KubeAutomation/vars/output.yml
(add node ip in whatever role you want)
./kubedep.sh scale
```
2. kubeadm
```
(on k8s master)  kubeadm token create --print-join-command
(on node you wanna join , require: docker , kubelet) paste join command
```

* upgrade k8s cluster (testing)
```
./kubedep.sh upgrade v1.13.5
```
