#!/bin/bash

  function terraform() {
      [[ -z "$rhv_host_count" ]] && rhv_host_count=1

      docker run --rm -it --env TF_VAR_rhv_host_count=$rhv_host_count --env GOOGLE_CLOUD_KEYFILE_JSON=ocp-on-rhv-service.json -v $(pwd):/opt/app -v ~/.ssh:/home/terraform/.ssh contino/terraform "$@";
    }


    function ansible-playbook() {
    docker run --rm \
    -e USER=ansible \
    -e MY_UID=$(id -u) \
    -e MY_GID=$(id -g) \
    -v ${HOME}/.ssh/:/home/ansible/.ssh/:ro  -v $(pwd):/data quay.io/eslutsky/ansible:latest-tools ansible-playbook "$@";
    }

    function ansible() {
    docker run --rm \
    -e USER=ansible \
    -e MY_UID=$(id -u) \
    -e MY_GID=$(id -g) \
    -v ${HOME}/.ssh/:/home/ansible/.ssh/:ro  -v $(pwd):/data quay.io/eslutsky/ansible:latest-tools ansible "$@";
    }


    function ansible-inventory() {
    docker run --rm \
    -e USER=ansible \
    -e MY_UID=$(id -u) \
    -e MY_GID=$(id -g) \
    -v ${HOME}/.ssh/:/home/ansible/.ssh/:ro  -v $(pwd):/data quay.io/eslutsky/ansible:latest-tools ansible-inventory "$@";
    }


    function ansible-doc() {
    docker run --rm \
    -e USER=ansible \
    -e MY_UID=$(id -u) \
    -e MY_GID=$(id -g) \
    -v ${HOME}/.ssh/:/home/ansible/.ssh/:ro  -v $(pwd):/data quay.io/eslutsky/ansible:latest-tools ansible-doc "$@";
    }
