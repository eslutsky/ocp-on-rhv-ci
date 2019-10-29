#!/usr/bin/env python

# Terraform-Ansible dynamic inventory for GCP
# Convert Terraform-GCE tfstate file to Ansible Inventory

import json
import configparser
import os
from os import getenv
from collections import defaultdict
from argparse import ArgumentParser


def parse_params():
    parser = ArgumentParser('GCP Cloud Terraform inventory')
    parser.add_argument('--list', action='store_true', default=True, help='List Terraform hosts')
    parser.add_argument('--tfstate', '-t', action='store', dest='tfstate', help='Terraform state file in current or specified directory (terraform.tfstate default)')
    parser.add_argument('--version', '-v', action='store_true', help='Show version')
    args = parser.parse_args()
    # read location of terrafrom state file from ini if it exists
    if not args.tfstate:
        dirpath = os.getcwd()
        tf_file = dirpath + "/terraform.tfstate"
        tf_file = os.path.expanduser(tf_file)
        args.tfstate = tf_file
    return args


def get_tfstate(filename):
    return json.load(open(filename))

def parse_state(tf_source, prefix, sep='.'):
    for key, value in list(tf_source.items()):
        try:
            curprefix, rest = key.split(sep, 1)
        except ValueError:
            continue
        if curprefix != prefix or rest == '#':
            continue

        yield rest, value


def parse_attributes(tf_source, prefix, sep='.'):
    attributes = defaultdict(dict)
    for key, value in parse_state(tf_source, prefix, sep):
        index, key = key.split(sep, 1)
        attributes[index][key] = value

    return list(attributes.values())


def parse_dict(tf_source, prefix, sep='.'):
    return dict(parse_state(tf_source, prefix, sep))

def parse_list(tf_source, prefix, sep='.'):
    return [value for _, value in parse_state(tf_source, prefix, sep)]

class TerraformInventory:
    def __init__(self):
        self.args = parse_params()
        if self.args.version:
            print(ti_version)
        elif self.args.list:
            print(self.list_all())

    def list_all(self):
        #tf_hosts = []
        hosts_vars = {}
        attributes = {}
        groups = {}
        groups_json = {}
        inv_output = {}
        group_hosts = defaultdict(list)
        for name, attributes, groups in self.get_tf_instances():
            #tf_hosts.append(name)
            hosts_vars[name] = attributes
            for group in list(groups):
                #print(group)
                group_hosts[group].append(name)
                #print(group_hosts.items())

        for group in group_hosts:
            inv_output[group] = {'hosts': group_hosts[group]}
        inv_output["_meta"] = {'hostvars': hosts_vars}
        return json.dumps(inv_output, indent=2)
        #return json.dumps({'all': {'hosts': hosts}, '_meta': {'hostvars': hosts_vars}}, indent=2)

    def get_tf_instances(self):
        tfstate = get_tfstate(self.args.tfstate)

        for resource in tfstate['resources']:

            if resource['type'] == 'google_compute_instance':
                #print  resource['instances'][0]['attributes']['id']
                tf_attrib = resource['instances'][0]['attributes']
                # print(tf_attrib)
                name = tf_attrib['id']
                group = ["gcp-instances"]

                attributes = {
                    'id': tf_attrib['id'],
                    'ipv4_address': tf_attrib['network_interface'][0]['network_ip'],
                    'public_ipv4': tf_attrib['network_interface'][0]['access_config'][0]['nat_ip'],
                    'private_ipv4': tf_attrib['network_interface'][0]['network_ip'],
                    'ansible_host': tf_attrib['network_interface'][0]['access_config'][0]['nat_ip'],
                    'ansible_ssh_user': 'centos',
                    'provider': 'google',
                }
                # user_metadata is an optional IBM provider value
                if 'user_metadata' in tf_attrib:
                        attributes['metadata'] = tf_attrib['user_metadata']

                yield name, attributes, group



            else:
                continue



if __name__ == '__main__':
    TerraformInventory()
