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
  ./assign-access-ips.sh
  ansible-playbook -u centos -i inventory.compute.gcp.yml  rhv-on-gcp.yml

  ```

## scaling the environment up

  ```shell
  source env.sh
  rhv_host_count=4 terraform apply
  ./assign-access-ips.sh
  ansible-playbook -u centos -i inventory.compute.gcp.yml rhv-on-gcp-scale.yml
  ```

## copy  ovirt cluster json  to the openshift CI secret

   ```shell
   oc login ..
   oc create secret generic  ovirt-infra-secrets --from-file=res/ --dry-run -o yaml | oc replace -f -
   ```

---

## files

| File  | Description |
|---|----|
| assign-access-ips.sh  | script that allocated static public IPs to the VMS   |
| ip_hosts.csv |  csv mapping files between cluster FQDN and public static IP address  |

