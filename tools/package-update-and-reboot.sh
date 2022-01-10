#!/bin/bash

# Update packages on one or more nodes.
# This script accepts exactly one argument - the limit to pass to Ansible.

set -eux

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <limit>"
    exit 1
fi

export ANSIBLE_SERIAL=${ANSIBLE_SERIAL:-0}

host=$1

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-disable.yml --limit $host

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-drain.yml --limit $host

# FIXME(priteau): serial doesn't apply to Kayobe commands
kayobe overcloud host package update --limit $host --packages "*"

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/reboot.yml --limit $host

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-enable.yml --limit $host
