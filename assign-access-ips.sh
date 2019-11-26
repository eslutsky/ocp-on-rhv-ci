#!/bin/bash

if [ -z $KUBERNETES_PORT ] ; then
source env.sh
fi
source gcloud_utils.sh


free_ip=""

vms=()
## assigned public  static ip to engine (if missing)
get_vms_without_public_ips  'ocp-rhv-vm-engine'
if [ $? -eq 0 ] ;
then
  get_free_public_ip '.*static-ip-engine'
  if [ $? -eq 0 ] ;
  then
    echo "assigning public ip - ${free_ip} to ${vms} VM"
    gcloud compute instances add-access-config ${vms} --address ${free_ip} --zone us-central1-b
  fi
fi

## assigned public  static ip to first host (if missing)
get_vms_without_public_ips  '^ocp-rhv-nested-vm-host$'
if [ $? -eq 0 ] ;
then
  get_free_public_ip 'ocp-rhv-static-ip-host-00'
  if [ $? -eq 0 ] ;
  then
    echo "assigning public ip - ${free_ip} to ${vms} VM"
    gcloud compute instances add-access-config ${vms} --address ${free_ip} --zone us-central1-b
  fi
fi

## assigned public ips to the scaled hosts
get_vms_without_public_ips '^ocp-rhv-nested-vm-host-.*'
if [ $? -eq 0 ] ;
then
  for element in "${vms[@]}"
  do
      get_free_public_ip 'ocp-rhv-static-ip-host-[0-9][1-9]'
      if [ $? -eq 0 ] ;
      then
          echo "assigning public ip - ${free_ip} to $element VM"
          gcloud compute instances add-access-config $element --address ${free_ip} --zone us-central1-b
      fi
  done
fi
