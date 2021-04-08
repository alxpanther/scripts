#!/bin/bash

# In .bash_profile insert:
# PATH=$PATH:$HOME/bin:/usr/local/bin

dnf -y install rsync

git clone https://github.com/ansible-ThoTeam/nexus3-oss.git
cd nexus3-oss

python3 -m pip install -U pip
python3 -m pip install -r requirements.txt

cd ..
rm -rf nexus3-oss

/usr/local/bin/ansible-galaxy install geerlingguy.java
/usr/local/bin/ansible-galaxy install geerlingguy.apache
/usr/local/bin/ansible-galaxy install ansible-thoteam.nexus3-oss

/usr/local/bin/ansible-playbook nexus.yml
