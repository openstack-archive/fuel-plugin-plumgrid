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

notice('MODULAR: plumgrid/director.pp')

# Fuel settings
$fuel_hash              = hiera_hash('public_ssl', {})
$fuel_hostname          = pick($fuel_hash['hostname'])

# PLUMgrid settings
$plumgrid_hash          = hiera_hash('plumgrid', {})
$plumgrid_pkg_repo      = pick($plumgrid_hash['plumgrid_package_repo'])
$plumgrid_lic           = pick($plumgrid_hash['plumgrid_license'])
$plumgrid_vip           = pick($plumgrid_hash['plumgrid_virtual_ip'])
$plumgrid_zone          = pick($plumgrid_hash['plumgrid_zone'])
$plumgrid_username      = pick($plumgrid_hash['plumgrid_username'])
$plumgrid_password      = pick($plumgrid_hash['plumgrid_password'])

# PLUMgrid Zone settings
$network_metadata       = hiera_hash('network_metadata')
$haproxy_vip            = pick($network_metadata['vips']['public']['ipaddr'])
$controller_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$controller_address_map = get_node_to_ipaddr_map_by_network_role($controller_nodes, 'mgmt/vip')
$controller_ipaddresses = join(hiera_array('controller_ipaddresses', values($controller_address_map)), ',')
$mgmt_net               = hiera('management_network_range')
$fabric_dev             = hiera('fabric_dev')

# Neutron settings
$neutron_config         = hiera_hash('quantum_settings', {})
$metadata_secret        = pick($neutron_config['metadata']['metadata_proxy_shared_secret'], 'root')
$service_endpoint       = hiera('service_endpoint')

# Neutron DB settings
$neutron_db_password    = $neutron_config['database']['passwd']
$neutron_db_user        = pick($neutron_config['database']['user'], 'neutron')
$neutron_db_name        = pick($neutron_config['database']['name'], 'neutron')
$neutron_db_host        = pick($neutron_config['database']['host'], hiera('database_vip'))

$neutron_db_uri = "mysql://${neutron_db_user}:${neutron_db_password}@${neutron_db_host}/${neutron_db_name}?&read_timeout=60"

# OpenStack Access settings
$access_hash              = hiera_hash('access', {})
$admin_password           = pick($access_hash['password'])

# Add fuel node fqdn to /etc/hosts
host { 'fuel':
    ip => $haproxy_vip,
    host_aliases => $fuel_hostname,
}

class { 'plumgrid':
  plumgrid_ip  => $controller_ipaddresses,
  mgmt_dev     => 'br-mgmt',
  fabric_dev   => $fabric_dev,
  lvm_keypath   => "/var/lib/plumgrid/zones/$plumgrid_zone/id_rsa.pub",
}

class { 'sal':
  plumgrid_ip => $controller_ipaddresses,
  virtual_ip  => $plumgrid_vip,
}

class { plumgrid::firewall:
  source_net => $mgmt_net,
  dest_net   => $mgmt_net,
}

# Setup Neutron PLUMgrid Configurations

package { 'neutron-server':
  ensure => 'present',
  name   => 'neutron-server',
}

service { 'neutron-server':
  ensure     => 'running',
  name       => 'neutron-server',
  enable     => true,
}

file { '/etc/neutron/neutron.conf':
  ensure => present,
  notify => Service['neutron-server'],
}

file_line { 'Enable PLUMgrid core plugin':
  path => '/etc/neutron/neutron.conf',
  line => 'core_plugin=neutron.plugins.plumgrid.plumgrid_plugin.plumgrid_plugin.NeutronPluginPLUMgridV2',
  match => '^core_plugin.*$',
  require => File['/etc/neutron/neutron.conf'],
}

file_line { 'Disable service plugins':
  path => '/etc/neutron/neutron.conf',
  line => 'service_plugins = ""',
  match => '^service_plugins.*$',
  require => File['/etc/neutron/neutron.conf'],
}

file { '/etc/nova/nova.conf':
  ensure => present,
  notify => Service['neutron-server'],
}

file_line { 'Set libvirt vif':
  path => '/etc/nova/nova.conf',
  line => 'libvirt_vif_type=ethernet',
  match => '^libvirt_vif_type.*$',
  require => File['/etc/nova/nova.conf']
}

file_line { 'Set libvirt cpu mode':
  path => '/etc/nova/nova.conf',
  line => 'libvirt_cpu_mode=none',
  match => '^libvirt_cpu_mode.*$',
  require => File['/etc/nova/nova.conf']
}

file { '/etc/apache2/ports.conf':
  ensure => present,
}

file_line { 'ensure no port conflict between apache and keystone':
  path    => '/etc/apache2/ports.conf',
  line   => 'NameVirtualHost *:35357',
  ensure  => 'absent',
  require => File['/etc/apache2/ports.conf']
}

file_line { 'ensure no port conflict between apache-keystone':
  path    => '/etc/apache2/ports.conf',
  line   => 'NameVirtualHost *:5000',
  ensure  => 'absent',
  require => File['/etc/apache2/ports.conf']
}

# Setting PLUMgrid Config Files

class { '::neutron::plugins::plumgrid':
  director_server              => $plumgrid_vip,
  username                     => $plumgrid_username,
  password                     => $plumgrid_password,
  admin_password               => $admin_password,
  controller_priv_host         => $service_endpoint,
  connection                   => $neutron_db_uri,
  nova_metadata_ip             => '169.254.169.254',
  nova_metadata_port           => '8775',
  metadata_proxy_shared_secret => $metadata_secret,
}->
package { 'networking-plumgrid':
  ensure   => latest,
  provider => 'pip',
  notify   => Service["$::neutron::params::server_service"],
}
