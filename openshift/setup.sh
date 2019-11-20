#!/bin/bash

git clone https://github.com/eslutsky/ocp-on-rhv-ci.git
cd ocp-on-rhv-ci
ln -s /runner/gcp-secrets/ocp-on-rhv-service.json ocp-on-rhv-service.json
ansible-inventory -i inventory.compute.gcp.yml host --list
ansible-playbook -u centos -i inventory.compute.gcp.yml  rhv-on-gcp-scale.yml

echo "cleaning up"
cd ../
rm -rf ocp-on-rhv-ci/
