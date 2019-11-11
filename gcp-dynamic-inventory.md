
# install gcp with service account
tar xvfz ~/Downloads/google-cloud-sdk-270.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file=ocp-on-rhv-service.json


alias gcloud="/home/eslutsky/dev/projects/eslutsky-tools/cloud/gcp/google-cloud-sdk/bin/gcloud"


gcloud config set project openshift-gce-devel

#list running VMs for given IGM + Zone
gcloud compute instance-groups managed  list-instances  ocp-rhv-nested-vm-host-igm --zone=us-central1-b --format json

[
  {
    "currentAction": "NONE",
    "id": "4720486372692324930",
    "instance": "https://www.googleapis.com/compute/v1/projects/openshift-gce-devel/zones/us-central1-b/instances/ocp-rhv-nested-vm-host-4lwm",
    "instanceStatus": "RUNNING",
    "version": {
      "instanceTemplate": "https://www.googleapis.com/compute/v1/projects/openshift-gce-devel/global/instanceTemplates/rhv-host-template"
    }
  },
  {
    "currentAction": "NONE",
    "id": "7393081496919470658",
    "instance": "https://www.googleapis.com/compute/v1/projects/openshift-gce-devel/zones/us-central1-b/instances/ocp-rhv-nested-vm-host-nmm9",
    "instanceStatus": "RUNNING",
    "version": {
      "instanceTemplate": "https://www.googleapis.com/compute/v1/projects/openshift-gce-devel/global/instanceTemplates/rhv-host-template"
    }
  }
]



# with GCP dynamic inventory
# reference: http://matthieure.me/2018/12/31/ansible_inventory_plugin.html
https://raw.githubusercontent.com/ansible/ansible/devel/lib/ansible/plugins/inventory/gcp_compute.py
pip install requests
pip install google-auth

ocp-rhv-nested-vm-host-4lwm

# list the  vms from the list - by tag
ansible-inventory -i inventory.compute.gcp.yml --list
