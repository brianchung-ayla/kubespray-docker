FROM ubuntu:16.04
MAINTAINER BrianChung

RUN apt-get update \
&& apt-get install -y git python python-pip vim \
&& git clone -b "v2.9.0" --single-branch --depth 1 https://github.com/kubernetes-sigs/kubespray.git \
&& sed -i '/ansible/s/>=2.7.6/==2.7.9/g' /kubespray/requirements.txt \
&& pip install -r /kubespray/requirements.txt \
&& cp -rfp /kubespray/inventory/sample /kubespray/inventory/mycluster

COPY entrypoint.sh /
WORKDIR /kubespray
ENTRYPOINT ["/entrypoint.sh"]
