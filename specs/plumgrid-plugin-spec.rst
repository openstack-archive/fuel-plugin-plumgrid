..

Copyright 2016 PLUMgrid Inc.

=====================
PLUMgrid Fuel Plugin
=====================

The PLUMgrid plugin for Fuel provides the capability to use PLUMgrid
ONS as the entire network backend for Mirantis OpenStack. This utilizes
the PLUMgrid core nuetron plugin in collaboration with PLUMgrid Director,
Edge and Gateway components.

--------------------
Problem description
--------------------

PLUMgrid is a core neutron networking plugin that has been a part of OpenStack
neutron since Grizzly. It offers a Network Virtualization Platform that uses
direct communication with the Hypervisor layer to provide all the networking
functionality requested through Neutron APIs. The PLUMgrid Neutron Plugin
implements Neutron v2 APIs and helps configure L2/L3 virtual networks
created through the PLUMgrid Platform. It also implements External Networks
and Port Binding Extensions.

APIs supported by the PLUMgrid plugin:
 - Networks
 - Subnets
 - Ports
 - External Networks
 - Routers
 - Security Groups
 - Quotas
 - Port Binding
 - Provider Networks

----------------
Proposed changes
----------------

Implement a Fuel plugin that deploys PLUMgrid as the core neutron plugin 
and configure Mirantis OpenStack to use PLUMgrid as the networking backend.
The plugin deployment will also include deploying PLUMgrid Zone components
which reside on the controller and compute nodes to interact with the cluster.


------------
Alternatives
------------

None.

--------------
Upgrade impact
--------------

If this change set concerns any kind of upgrade process, describe how it is
supposed to deal with that stuff. For example, Fuel currently supports
upgrading of master node, so it is necessary to describe whether this patch
set contradicts upgrade process itself or any supported working feature that.

---------------
Security impact
---------------

None.

--------------------
Notifications impact
--------------------

None.

---------------
End user impact
---------------

End users will be able to leverage the enhanced scale and operational
capabilities provided by the PLUMgrid plugin when choosing to install
this plugin. Further details can be found in the References section below.

------------------
Performance impact
------------------

Same as End user impact.

-----------------
Deployment impact
-----------------

The PLUMgrid plugin tasks all run in post_deployment.

----------------
Developer impact
----------------

None.

--------------------
Documentation impact
--------------------

Documentation describing how to configure the Fuel UI PLUMgrid plugin
parameters to install PLUMgrid, will be required. This will be
deployer documentation.


Implementation
--------------

Assignee(s)
===========

Primary assignee:
* Javeria Khan <javeriak@plumgrid.com> https://launchpad.net/~javeria-ak

Other contributors:

* Abdullah Khan <abdullah.khan@plumgrid.com>

Work Items
==========

* Implement the Fuel plugin.
* Implement the Puppet manifests.
* Testing (CI verification and QA automatic and manual tests).
* Write the documentation.

Dependencies
============

* Fuel 7.0 pr higher.
* PLUMgrid-Gateway node must be deployed.

------------
Testing, QA
------------

* Functional, Tempest & Rally suites will be run on deployment.
* Test the plugin upgrades on a running enviroment.
* Test PLUMgrid ONS upgardes on a running enviroment.

----------
References
----------

* http://www.plumgrid.com/
* https://wiki.openstack.org/wiki/PLUMgrid-Neutron
