#!/bin/bash

# Update packages on one or more nodes.
# This script accepts exactly one argument - the limit to pass to Ansible.

set -eux

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <limit>"
    exit 1
fi

host=$1

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-disable.yml --limit $host

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-drain.yml --limit $host

kayobe overcloud host package update --limit $host --packages "*"

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/reboot.yml --limit $host

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/nova-compute-enable.yml --limit $host
