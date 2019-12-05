#!/bin/bash

cd gcp-ws/
git clone https://github.com/eslutsky/ocp-on-rhv-ci.git
cd ocp-on-rhv-ci
ln -s /runner/gcp-secrets/ocp-on-rhv-service.json ocp-on-rhv-service.json

cat <<__EOF__ >~/.ansible.cfg
[defaults]
host_key_checking = False
__EOF__


ansible-inventory -i inventory.compute.gcp.yml host --list
ansible-playbook -u centos --private-key=/runner/gcp-secrets/id_rsa -i inventory.compute.gcp.yml "$@"



echo "cleaning up"
cd ../
#rm -rf ocp-on-rhv-ci/
