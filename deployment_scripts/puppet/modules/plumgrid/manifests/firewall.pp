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

class plumgrid::firewall (
  $source_net = undef,
  $dest_net = undef,
) {

  if $source_net != undef {
    firewall { '001 plumgrid udp':
      proto       => 'udp',
      action      => 'accept',
      state       => ['NEW'],
      destination => $dest_net,
      source      => $source_net,
      before      => Class['plumgrid'],
    }
    firewall { '001 plumgrid rpc':
      proto       => 'tcp',
      action      => 'accept',
      state       => ['NEW'],
      destination => $dest_net,
      source      => $source_net,
      before      => Class['plumgrid'],
    }
    firewall { '040 allow vrrp':
      proto       => 'vrrp',
      action      => 'accept',
      before      => Class['plumgrid'],
    }
    firewall { '040 keepalived':
      proto       => 'all',
      action      => 'accept',
      destination => '224.0.0.18/32',
      source      => $source_net,
      before      => Class['plumgrid'],
    }
  }
}
