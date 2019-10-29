## GCP env for ocp-on-rhv-ci

---
### provision GCP ENV for running CI jobs

- pre-req
  - obtain service key json from GCP.
  - generate ssh key pair to access the env
  - create image with centos host on gcp with VMX License.
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

- provision ENV on GCP using  terraform
  - create terraform wrapper function:

    ```shell
    function terraform() {
      docker run --rm -it --env GOOGLE_CLOUD_KEYFILE_JSON=ocp-on-rhv-service.json -v $(pwd):/opt/app -v ~/.ssh:/home/terraform/.ssh contino/terraform "$@";
    }

    ```

  - run env provisioning
    ```shell
    terraform init
    terraform apply

    ```



- run ansible to install ovirt on GCP
  - running ansible
    ```shell
    docker run --rm -v $(pwd):/data cytopia/ansible ansible-playbook playbook.yml

    function ansible-playbook() {
    docker run --rm \
    -e USER=ansible \
    -e MY_UID=$(id -u) \
    -e MY_GID=$(id -g) \
    -v ${HOME}/.ssh/:/home/ansible/.ssh/:ro  -v $(pwd):/data  cytopia/ansible:latest-tools ansible-playbook "$@";
    }

    ansible-playbook  -i ./terraform_gce_inv.py  test.yml

    ```


---
TODO:
---

- provision ovirt on gcp env using terraform:
  - [x] create gcp network + subnet
  - [x] create Firewall rules for network
  - [x] Create VM instances with ssh keys
  - [ ] Static ip address assigment
  - [ ] create dns reservation


- rhv installation on gcp:
  - [X] add rhv repo to the engine
  - [X] prepare engine silent configuration file
  - [X] run engine-setup from engine
  - [ ] prepare host silent configuration file
  - [ ] add rhv repo to the host
  - [ ] run add host to engine


- prepare rhv host to support nested VMs
  - [ ] sshd Configration
  - [ ] in host: Allow direct root access only from 10.0.0.0/24
  - [ ] in host: dns masq configuration for nested VMs ovirtmgmt .
  - [ ] port forwarding for the ocp api.



- https://hub.docker.com/r/philm/ansible_target/



- installing terraform-inventory
  ```shell
  /bin/sh -c
  wget https://github.com/adammck/terraform-inventory/releases/download/v0.9/ terraform-inventory_0.9_linux_amd64.zip

  unzip -d /tmp/tf terraform-inventory_0.9_linux_amd64.zip  sudo mv /tmp/tf/terraform-inventory /usr/local/bin
  rm terraform-inventory_0.9_linux_amd64.zip
  rm -rf /tmp/tf
  ```