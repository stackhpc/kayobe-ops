#!/bin/bash

# Migrate to CentOS Stream 8 on one or more nodes.
# This script accepts exactly one argument - the limit to pass to Ansible.

set -eux

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <limit>"
    exit 1
fi

PARENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

host=$1

kayobe playbook run -vv $KAYOBE_CONFIG_PATH/ansible/migrate-to-centos-stream.yml --limit $host

$PARENT/package-update-and-reboot.sh ${@}
