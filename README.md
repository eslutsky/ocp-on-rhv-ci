## GCP env for ocp-on-rhv-ci

---

## pre-req

- obtain service key json from GCP.
- generate ssh key pair to access the env
- create image with centos host on gcp with VMX License.
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

## bringing-up the environment

  ```shell
  source env.sh
  terraform init
  terraform apply
  ansible-playbook  -i inventory.compute.gcp.yml  rhv-on-gcp.yml

  ```

## scaling the environment up

  ```shell
  source env.sh
  rhv_host_count=5 terraform apply
  ansible-playbook  -i inventory.compute.gcp.yml rhv-on-gcp-scale.yml
  ```

---

### TODO

- [X] check engine version to support  correct ignition params.
- [ ] add dns static reservation
- [ ] add check lookup reservation
