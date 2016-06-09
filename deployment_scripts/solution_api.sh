#
# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

mkdir -p /var/log/plumgrid
exec > /var/log/plumgrid/solution_api.log
exec 2>&1

set -x

. /tmp/plumgrid_config

# Get required additional parameters
kernel_version=$(uname -r)
hypervisor_type=$(echo $(lsb_release -i) | cut -d' ' -f3)
hypervisor_version=$(echo $(lsb_release -r) | cut -d' ' -f2)
plumgrid_version=$(dpkg -l | awk '$2=="plumgrid-lxc" { print $3 }' | cut -d'-' -f1 )
if [ -d /var/lib/libvirt/filesystems/plumgrid/opt/pg/web/cloudApex/modules/appCloudApex/appCloudApex.js ]; then
  cloudapex_version=$(cat /var/lib/libvirt/filesystems/plumgrid/opt/pg/web/cloudApex/modules/appCloudApex/appCloudApex.js | grep -i appVersion | awk '{print $2; exit}' | cut -d ',' -f 1)
  else
  cloudapex_version="0.0"
fi

# Push all IPs info to Solution API server
curl -H 'Content-Type: application/json' -X PUT -d '{"director_ips":"'$director_ip'","edge_ips":"'$edge_ip'","gateway_ips":"'$gateway_ip'","virtual_ip":"'$vip'","opsvm_ip":"'$opsvm_ip'"}' http://$pg_repo:8099/v1/zones/$plumgrid_zone/ALLIPS

# Push zone info to Solution API server
curl -H "Content-Type: application/json" -X PUT -d '{"solution_name":"Mirantis","solution_version":"'$fuel_version'","pg_ons_version":"'$plumgrid_version'","hypervisor":"'$hypervisor_type'","hypervisor_version":"'$hypervisor_version'", "kernel_version":"'$kernel_version'","pg_cloudapex_version":"'$cloudapex_version'"}' http://$pg_repo:8099/v1/zones/$plumgrid_zone/zoneInfo
