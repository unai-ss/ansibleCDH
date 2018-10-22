#!/bin/bash
# agrega extras de cd en red hat
#https://access.redhat.com/solutions/1355683
#centos 7
#on remote pc  /etc/ssh/sshd_config 'PasswordAuthentication yes'
echo 'configuracion ansible'
sudo adduser -m  ansible
printf 'CambiaPass\nCambiaPass' | sudo passwd ansible
sudo usermod -aG wheel ansible
#centos
sudo yum install epel-release -y
#rhel
sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo subscription-manager repos --enable rhel-7-server-extras-rpms
sudo yum update -y
sudo yum install ansible vim lsof wget expect -y
sudo cat <<EOF >/tmp/hosts
[servers]
host1 ansible_ssh_host=172.20.187.71
host2 ansible_ssh_host=172.20.187.72
host3 ansible_ssh_host=172.20.187.73
host4 ansible_ssh_host=172.20.187.74
host5 ansible_ssh_host=172.20.187.75
EOF
sudo cp /tmp/hosts /etc/ansible/hosts
sudo mkdir -p /etc/ansible/group_vars
sudo cat <<EOF >/tmp/servers
---
ansible_ssh_user: ansible
EOF
sudo cp /tmp/servers /etc/ansible/group_vars/servers
echo 'fin configuracion ansible'
su ansible
sudo ssh-keygen -t rsa -f /home/ansible/.ssh/id_rsa -q -P ""
for ip in `cut -d '=' -f 2 /etc/ansible/hosts`; do
    sudo ssh root@$ip adduser -m ansible;
    sudo ssh root@$ip passwd ansible;
    sudo ssh root@$ip usermod -aG wheel ansible;
    sudo ssh-copy-id -i /home/ansible/.ssh/id_rsa ansible@$ip;
done
printf 'yes/n' | ansible -m ping all

####cloudera es obligatorio tener root en la instalacion
####como root
sudo ssh-keygen -t rsa -q -P ""
for ip in `cut -d '=' -f 2 /etc/ansible/hosts`; do
    sudo ssh-copy-id -root@$ip;
done
