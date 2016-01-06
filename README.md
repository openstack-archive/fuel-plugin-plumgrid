PLUMgrid plugin for Mirantis Fuel
=================================

License
-------
Copyright 2015 PLUMgrid Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

PLUMgrid Plugin
---------------
PLUMgrid is a core neutron networking plugin that has been a part of OpenStack
neutron since Grizzly. It offers a Network Virtualization Platform that uses
direct communication with the Hypervisor layer to provide all the networking
functionality requested through Neutron APIs. It implements Neutron v2 APIs
and helps configure L2/L3 virtual networks created through the PLUMgrid Platform.
It also implements External Networks and Port Binding Extensions.

Building the plugin
-------------------
1. Clone the PLUMgrid Fuel plugin repository:
   
 ``# git clone https://github.com/plumgrid/plumgrid-fuel-plugin.git``

2. Install Fuel Plugin Builder:

 ``pip install fuel-plugin-builder``

3. Navigate to the cloned PLUMgrid Fuel plugin folder and build the plugin:

 ``cd plumgrid-fuel-plugin/``
 
 ``fpb --build .``

3. The plumgrid-<x.x.x>.rpm plugin file will be created.

4. Copy this file to the Fuel Master node with secure copy (scp):

 ``scp plumgrid-<x.x.x>.rpm root@:<the_Fuel_Master_node_IP address>:/tmp``

5. On the Fuel Master node, Install the PLUMgrid plugin with:

 ``fuel plugins --install plumgrid-<x.x.x>.rpm``

6. The plugin is now ready for use and can be enabled on the Settings tab, PLUMgrid Plugin section
   of the Fuel web UI.

Note: Contact PLUMgrid for an Installation Pack info@plumgrid.com
(includes full/trial license, packages and deployment documentation)

