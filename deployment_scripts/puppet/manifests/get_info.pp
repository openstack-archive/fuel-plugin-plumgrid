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

notice('MODULAR: plumgrid/get_info.pp')

exec { "Get kernel version":
  command => "/bin/sed -i '/kernel_version/d' /etc/astute.yaml && /bin/echo \"kernel_version: $(uname -r)\" >> /etc/astute.yaml",
}

exec { "Get plumgrid version":
  command => "/bin/sed -i '/plumgrid_version/d' /etc/astute.yaml && /bin/echo \"plumgrid_version: $(dpkg -l | awk '\$2==\"plumgrid-lxc\" { print \$3 }' )\" >> /etc/astute.yaml",
}

exec { "Get cloudapex version":
  command => "/bin/sed -i '/cloudapex_version/d' /etc/astute.yaml && /bin/echo \"cloudapex_version: $(cat /var/lib/libvirt/filesystems/plumgrid/opt/pg/web/cloudApex/modules/appCloudApex/appCloudApex.js | grep -i appVersion | awk '{print \$2; exit}' | cut -d ',' -f 1)\" >> /etc/astute.yaml",
}
