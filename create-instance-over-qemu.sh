#!/bin/sh

# Need install 'virt-install' (!)

INSTANCE_NAME="front-1"
INSTANCE_CPU=28
INSTANCE_MEM=65535
INSTANCE_DISK=16G
#INSTANCE_OS_VARIANT="ubuntu20.04"
INSTANCE_OS_VARIANT="centos-stream8"
IMAGE_NAME="CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2" # CentOS Ctream 8
#IMAGE_NAME="focal-server-cloudimg-amd64.img" # Fedora

#DOCKER_TOKEN_STR="SWMTKN-1-XXXXXXXXXX IP.IP.IP.IP:2377"

# for Ubuntu Focal see in https://cloud-images.ubuntu.com/ for Ubuntu
# wget -c -nd -t0 "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
#
# for CentOS see in https://cloud.centos.org/centos/
#
# for Fedora 35 See in https://ftp.halifax.rwth-aachen.de/fedora/linux/releases/35/Cloud/x86_64/images/
# wget -c -nd -t0 "https://ftp.halifax.rwth-aachen.de/fedora/linux/releases/35/Cloud/x86_64/images/Fedora-Cloud-Base-35-1.2.x86_64.qcow2"

cat >user-data<<EOF
#cloud-config
users:
  - name: devops
    ssh-authorized-keys:
      - ssh-ed25519 XXXXXXXXXXXXXX
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
  - name: devops-2
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
#    lock_passwd: true
    ssh_authorized_keys:
      - ssh-ed25519 XXXXXXXXXX
  - name: root
    ssh_authorized_keys:
      - ssh-ed25519 XXXXXXXXXX

timezone: UTC

packages:
  - mc
  - git
  - telnet
  - unzip
  - tcpdump
  - traceroute
  - wget
  - bc
  - epel-release
#  - htop
#  - nload
#  - curl
  - net-tools

runcmd:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  - echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#  - apt -y update
#  - apt -y install docker-ce docker-ce-cli containerd.io python3 python3-pip
#  - docker swarm join --token ${DOCKER_TOKEN_STR}
#  - pip3 install --upgrade pip
#  - pip3 install docker-compose
#  - ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#  - cd /tmp && git clone https://github.com/bcicen/ctop ; cd ctop && ./install.sh ; ln -s /usr/local/bin/ctop /usr/bin/ctop
EOF


qemu-img create -f qcow2 -F qcow2 -o backing_file=${IMAGE_NAME} ${INSTANCE_NAME}.qcow2
qemu-img resize ${INSTANCE_NAME}.qcow2 ${INSTANCE_DISK}

echo "local-hostname: ${INSTANCE_NAME}" > meta-data

genisoimage  -output instance-cidata.iso -volid cidata -joliet -rock user-data meta-data
rm meta-data user-data

virt-install --connect qemu:///system --virt-type kvm --name ${INSTANCE_NAME} --ram ${INSTANCE_MEM} --vcpus=${INSTANCE_CPU} --os-type linux --os-variant ${INSTANCE_OS_VARIANT} --disk path=${INSTANCE_NAME}.qcow2,format=qcow2 --disk instance-cidata.iso,device=cdrom --import --network network=default --noautoconsole

virsh list

echo "Unmount CDROM image instance-cidata.is from ${INSTANCE_NAME} after complete CLOUD-INIT script!"
