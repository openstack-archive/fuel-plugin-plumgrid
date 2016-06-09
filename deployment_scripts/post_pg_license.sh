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
exec > /var/log/plumgrid/post_license.log
exec 2>&1

set -x

. /tmp/plumgrid_config

if [[ ! -f "/root/post_director" ]];then

  #Wait for the platform to come up
  sleep 5
  retry_cnt=0
  http_status=""

  while [[ "$http_status" != "200" ]]; do
    if [[ $retry_cnt -ge 150 ]]; then
      echo "Failed to login to platform for 5 minutes, exiting..."
      exit 1
    fi

    #Login to PLUMgrid
    http_status=$(curl -H "Accept: application/json" -H "Content-Type: application/json" -k -X \
    POST https://$vip/0/login -d '{"userName":"plumgrid","password":"plumgrid"}' \
    -c /tmp/cookie -i | grep HTTP | awk '{print $2}')

    echo $http_status

    let "retry_cnt= $retry_cnt + 1"
    sleep 2
  done

  #Install License
  install_status=$(curl -H "Accept: application/json" -H "Content-Type: application/json" -X PUT \
  -d '{"user_name":"plumgrid","password":"plumgrid","license":"'$license'"}' \
  http://$pg_repo:8099/v1/zones/$zone_name/pgLicense)

  echo $install_status

  if [[ $install_status -ne "{\"status\": \"success\",\"message\":\"Successfully installed PLUMgrid license\",\"data\":}" ]]; then
    echo "Error installing license, exiting..."
    exit 1
  fi

  touch /root/post_director

else
  echo "This Director has already been configured, skipping."
fi
