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

. /tmp/plumgrid_config

function check_and_replace() {
  local check_line=$1
  local replace_line=$2
  local file=$3
  grep -q "$check_line" $file
  if [[ $? -ne 0 ]]; then
    sed -i "$ a\\$replace_line" $file
  else
    sed -i "s/$check_line.*/$replace_line/g" $file
  fi
  return 0
}

fabric_ip=$(ip addr show br-mgmt | awk '$1=="inet" {print $2}' | awk -F '/' '{print $1}' | awk -F '.' '{print $4}' | head -1)
fabric_dev=$(brctl show br-mgmt | awk -F ' ' '{print $4}' | awk 'FNR == 2 {print}' | awk -F '.' '{print $1}')

# remove the default bridge, if it exists
BRIDGE_AUX=$(brctl show | grep br-aux || true)

if [[ ! -z "${BRIDGE_AUX}" ]];then

  brctl delif br-aux $fabric_dev
  ifconfig br-aux down
  brctl delbr br-aux
  rm -f /etc/network/interfaces.d/ifcfg-br-aux

fi

fabric_netmask=$(ifconfig br-mgmt | grep Mask | sed s/^.*Mask://)
fabric_net=$(echo $fabric_network | cut -f2 -d: | cut -f1-3 -d.)

ifconfig $fabric_dev $fabric_net.$fabric_ip netmask $fabric_netmask
ifconfig $fabric_dev mtu 1580

check_and_replace "iface " "iface $fabric_dev inet static" /etc/network/interfaces.d/ifcfg-$fabric_dev
check_and_replace "address " "address $fabric_net.$fabric_ip" /etc/network/interfaces.d/ifcfg-$fabric_dev
check_and_replace "netmask " "netmask $fabric_netmask" /etc/network/interfaces.d/ifcfg-$fabric_dev
check_and_replace "mtu " "mtu 1580" /etc/network/interfaces.d/ifcfg-$fabric_dev

sed -i "/bridge_port.*/d" /etc/network/interfaces.d/ifcfg-$fabric_dev

grep -q -F "fabric_dev: $fabric_dev" /etc/astute.yaml || echo "fabric_dev: $fabric_dev" >> /etc/astute.yaml

