# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

notice('MODULAR: plumgrid/solutions_api.pp')

# Node IPs
$network_metadata       = hiera_hash('network_metadata')
$controller_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$controller_address_map = get_node_to_ipaddr_map_by_network_role($controller_nodes, 'mgmt/vip')
$controller_ipaddresses = join(hiera_array('controller_ipaddresses', values($controller_address_map)), ',')
$compute_nodes          = get_nodes_hash_by_roles($network_metadata, ['compute'])
$compute_address_map    = get_node_to_ipaddr_map_by_network_role($compute_nodes, 'mgmt/vip')
$compute_ipaddresses    = join(hiera_array('compute_ipaddresses', values($compute_address_map)), ',')
$gateway_nodes          = get_nodes_hash_by_roles($network_metadata, ['PLUMgrid-Gateway'])
$gateway_address_map    = get_node_to_ipaddr_map_by_network_role($gateway_nodes, 'mgmt/vip')
$gateway_ipaddresses    = join(hiera_array('gateway_ipaddresses', values($gateway_address_map)), ',')
$plumgrid_hash          = hiera_hash('plumgrid', {})
$plumgrid_pkg_repo      = pick($plumgrid_hash['plumgrid_package_repo'])
$md_ip                  = pick($plumgrid_hash['plumgrid_opsvm'])
$plumgrid_vip           = pick($plumgrid_hash['plumgrid_virtual_ip'])
$plumgrid_zone          = pick($plumgrid_hash['plumgrid_zone'])
$openstack_version      = hiera('openstack_version')
$cobbler                = hiera_hash('cobbler')
$hypervisor             = pick($cobbler['profile'])
$kernel_version         = hiera('kernel_version')
$plumgrid_version       = hiera('plumgrid_version')
$cloudapex_version      = hiera('cloudapex_version','disabled')

exec { 'Send all IPs to Solution API server':
  command => "/usr/bin/curl -H \'Content-Type: application/json\' -X PUT -d \'{\"director_ips\":\"$controller_ipaddresses\",\"edge_ips\":\"$compute_ipaddresses\",\"gateway_ips\":\"$gateway_ipaddresses\",\"virtual_ip\":\"$plumgrid_vip\",\"opsvm_ip\":\"$md_ip\"}\' http://$plumgrid_pkg_repo:8099/v1/zones/$plumgrid_zone/ALLIPS" }

exec { 'Send Environment data to Solution API server':
  command => "/usr/bin/curl -H \"Content-Type: application/json\" -X PUT -d \'{\"solution_name\":\"Mirantis\",\"solution_version\":\"$openstack_version\",\"pg_ons_version\":\"$plumgrid_version\",\"hypervisor\":\"$hypervisor\",\"hypervisor_version\":\"$hypervisor\", \"kernel_version\":\"$kernel_version\",\"pg_cloudapex_version\":\"cloudapex_version\"}\' http://$plumgrid_pkg_repo:8099/v1/zones/$plumgrid_zone/zoneInfo" }
