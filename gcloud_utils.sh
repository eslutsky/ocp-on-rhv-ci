#!/bin/bash


    function get_free_public_ip()
    {
      local regex_filter=$1
      free_ip=""
      free_ip=$(gcloud compute addresses list --filter="name~'${regex_filter}' \
      AND status:RESERVED" \
      --format='value(ADDRESS)' | head -1) >/dev/null
      [[ -z "$free_ip" ]] && return 1
      return 0
    }

    function get_vms_without_public_ips()
    {
      #[ "$DEBUG" == 'true' ] && set -x
      local regex_filter=$1
      vms=()
      vms=(`gcloud compute instances list --filter="name~'${regex_filter}' \
      AND -EXTERNAL_IP:*" --format='value(NAME)'`)
      [[ -z "$vms" ]] && return 1

      return 0

    }