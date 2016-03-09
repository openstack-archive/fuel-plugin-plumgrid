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
exec > /var/log/plumgrid/pg_os_version.log
exec 2>&1

set -x

. /tmp/plumgrid_config

curl -Lks http://$pg_repo:81/files/lvm-installer.sh  -o /tmp/lvm-installer.sh

curl -Lks http://$pg_repo:81/files/pg_os_version.yaml  -o /tmp/pg_os_version.yaml

pg_version=$(cat /tmp/lvm-installer.sh | grep pg_ver= | awk 'NR==1 {print}'| cut -c9-| sed 's/-.*//')

os_version=$(cat /tmp/pg_os_version.yaml | grep $pg_version-k | cut -d ' ' -f2)

if [ -n "$os_version" ]; then
  grep -q -F "networking_pg_version: $os_version" /etc/astute.yaml || echo "networking_pg_version: $os_version" >> /etc/astute.yaml
fi
